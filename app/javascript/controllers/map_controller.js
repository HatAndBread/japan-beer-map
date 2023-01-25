import { Controller } from "@hotwired/stimulus";
import { distance } from "lib/distance";
import debounce from "lodash.debounce";
import { useUserLocation } from "lib/use-user-location";
import { fitMapToBounds } from "lib/fit-map-to-bounds";

const startLngLat = [139.6503, 35.6762];
const maxBounds = [
  [121.83031059936349, 20.705762031300967], // Southwest coordinates
  [154.74125158604622, 49.413834542307185], // Northeast coordinates
];

export default class extends Controller {
  static targets = [
    "findMe",
    "nearestBeer",
    "userLocation",
    "toolsContainer",
    "toolsOpener",
    "toolsWrapper"
  ];
  connect() {
    const map = new mapboxgl.Map({
      container: "the-map",
      style: this.mapStyle(),
      center: startLngLat,
      zoom: 9,
      maxBounds: maxBounds,
    });
    map.addControl(
      new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        language: this.getLanguage(),
        mapboxgl,
      }),
      "top-left"
    );
    window.map = map;

    if (!"geolocation" in navigator) {
      this.findMeTarget.remove();
      this.nearestBeerTarget.remove();
      this.noGeolocation = true;
      window.noGeolocation = true;
    }

    const search = document.querySelector(".mapboxgl-ctrl-geocoder");
    document.getElementById("tools-content").prepend(search);
    const geoJson = JSON.parse(this.geoJson());
    this.___g = geoJson;
    const iconUrl = this.iconUrl();
    map.on("load", () => {
      map.loadImage(iconUrl, (error, image) => {
        if (error) throw new Error(error);
        this.toolsWrapperTarget.classList.remove("hidden");

        map.addImage("icon", image);
        if (window.userLocationMarker) window.userLocationMarker.remove();
        window.userLocationMarker = new mapboxgl.Marker(this.userLocationTarget)
          .setLngLat(startLngLat)
          .addTo(map);

        if (window.screen.width > 700) {
          // Let's assume it's a touch screen if the screen is smaller than 700.
          // Needed for accessibility if using an old fashioned mouse.
          map.addControl(new mapboxgl.NavigationControl(), "bottom-right");
        }

        this.addPlaceLayer(geoJson);

        map.on("click", "points", (e) => {
          const { id } = e.features[0].properties;
          document.getElementById(`place_${id}`).children[0].click();
        });
        this.handleMouseOver();
      });
    });
  }

  getLanguage() {
    return document.getElementsByName("i18n-lang")[0].dataset.lang;
  }

  iconUrl() {
    return (
      window.location.origin +
      document.getElementsByName("icon-url")[0].dataset.path
    );
  }

  geoJson() {
    return document.getElementById("geo-json").dataset.geoJson;
  }

  mapStyle() {
    if (this.getLanguage() === "ja") return window.japaneseURL;
    return window.englishURL;
  }

  handleChange() {
    const selectedTypes = this.selectedTypes();
    const legend = {
      is_brewery: "brewery",
      has_food: "food",
      is_shop: "shop",
    };
    const newGeoJson = {
      type: "geojson",
      data: {
        type: "FeatureCollection",
        features: [],
      },
    };
    this.___g.data.features.forEach((f) => {
      const myTypes = Object.keys(f.properties)
        .map((p) => (f.properties[p] && legend[p] ? legend[p] : null))
        .filter((p) => p);
      if (selectedTypes.find((t) => myTypes.includes(t))) {
        newGeoJson.data.features.push(f);
      }
    });
    this.removePlaceLayer();
    this.addPlaceLayer(newGeoJson);
  }

  selectedTypes() {
    return this.checkboxes()
      .filter((el) => el.checked)
      .map((el) => el.dataset.type);
  }
  checkboxes() {
    return Array.from(this.element.querySelectorAll("*")).filter(
      (el) => el.type === "checkbox"
    );
  }

  addPlaceLayer(geoJson) {
    const map = window.map;
    if (map.getSource("point")) return;
    map.addSource("point", geoJson);

    map.addLayer({
      id: "points",
      type: "symbol",
      source: "point", // reference the data source
      layout: {
        "icon-image": "icon", // reference the image
        "icon-size": 0.6,
        "icon-allow-overlap": true,
      },
    });
  }

  removePlaceLayer() {
    window.map.removeLayer("points");
    window.map.removeSource("point");
  }

  markers() {
    return Array.from(document.getElementsByClassName("marker"));
  }

  async findMe() {
    if (window.userLocation) {
      this.flyToUser();
    } else {
      this.findMeTarget.children[0].classList.remove("hidden");
      useUserLocation(() => {
        this.flyToUser();
      });
    }
  }

  flyToUser() {
    if (!window.userLocation)
      throw new Error("Must create userLocation before calling flyToUser");
    window.map.flyTo({
      center: window.userLocation,
      zoom: 14,
    });
  }

  closeTools() {
    this.toolsContainerTarget.classList.add("hidden");
    this.toolsOpenerTarget.classList.remove("hidden");
    this.toolsWrapperTarget.classList.add("!w-fit");
  }

  openTools() {
    this.toolsContainerTarget.classList.remove("hidden");
    this.toolsOpenerTarget.classList.add("hidden");
    this.toolsWrapperTarget.classList.remove("!w-fit");
  }

  nearestBeer() {
    const goToNearest = (closest) => {
      window.map.flyTo({
        center: { lng: parseFloat(closest.lng), lat: parseFloat(closest.lat) },
        zoom: 18,
      });
    };
    useUserLocation((location) => {
      goToNearest(this._nearestBeer(location));
    });
  }

  _nearestBeer(location) {
    return this.markers().reduce(
      (prev, curr) => {
        const { lng, lat, id } = curr.children[0].dataset;
        const d = distance(lng, lat, location.lng, location.lat);
        if (d < prev.distance) return { distance: d, id, lng, lat };
        else return prev;
      },
      { distance: 99999, id: 99999, lng: 0, lat: 0 }
    );
  }

  handleMouseOver() {
    const map = window.map;
    const markerDiv = document.createElement("div");
    const triangle = document.createElement("div");
    markerDiv.className =
      "relative hidden p-2 text-xl bg-white rounded pointer-events-none drop-shadow-lg text-slate-800";
    triangle.className =
      "w-0 h-0 border-t-[10px] border-t-white border-l-[10px] border-r-[10px] border-l-transparent border-r-transparent absolute bottom-[-10px] z-10 left-[calc(50%_-_14px)]";
    const marker = new mapboxgl.Marker(markerDiv, { offset: [0, -104] })
      .setLngLat(startLngLat)
      .addTo(map);
    map.on(
      "mouseenter",
      "points",
      () => (map.getCanvas().style.cursor = "pointer")
    );
    const handleMouseMove = debounce((e) => {
      const features = map.queryRenderedFeatures(e.point);
      if (features[0] && features[0].source === "point") {
        const properties = features[0].properties;
        const coordinates = { lng: properties.lng, lat: properties.lat };
        marker.setLngLat(coordinates);
        markerDiv.classList.remove("hidden");
        markerDiv.innerHTML = `<span class="underline font-semibold">${properties.name}</span>`;
        const types = document.createElement("pre");
        types.className = "font-sans"
        types.innerText = `Brewery: ${properties.is_brewery ? "🙆‍♀️" : "🙅‍♀️"}\nBottle Shop: ${properties.is_shop ? "🙆‍♀️" : "🙅‍♀️"}\nFood: ${properties.has_food ? "🙆‍♀️" : "🙅‍♀️"}`
        const instructions = document.createElement("div");
        instructions.innerText = "Click for more info"
        instructions.className = "text-sm"
        markerDiv.appendChild(types);
        markerDiv.appendChild(instructions);
        markerDiv.appendChild(triangle);
      }
    });
    map.on("mousemove", handleMouseMove);

    map.on("mouseleave", "points", () => {
      map.getCanvas().style.cursor = "grab";
      markerDiv.classList.add("hidden");
    });
  }
}
