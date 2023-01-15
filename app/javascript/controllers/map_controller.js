import { Controller } from "@hotwired/stimulus";
import { distance } from "lib/distance"

const startLngLat = [139.6503, 35.6762]
const maxBounds = [
  [123.29314338022773, 24.092580544132286], // Southwest coordinates
  [151.41816085625925, 46.53952466389388] // Northeast coordinates
  ]

export default class extends Controller {
  static targets = ["findMe", "nearestBeer", "userLocation"];
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
        mapboxgl
      }),
      "top-left"
    );
    this.map = map;
    window.map = map;

    if (!"geolocation" in navigator) {
      this.findMeTarget.remove();
      this.nearestBeerTarget.remove();
      this.noGeolocation = true;
    }
    const geoJson = JSON.parse(this.geoJson());
    this.___g = geoJson;
    const iconUrl = this.iconUrl();
    map.on("load", () => {
      map.loadImage(iconUrl, (error, image) => {
        if (error) throw new Error(error)

        map.addImage("icon", image);
        this.userLocationMarker = new mapboxgl.Marker(this.userLocationTarget).setLngLat(startLngLat).addTo(map);

        this.addPlaceLayer(geoJson);

        map.on("click", "points", (e) => {
          const {id} = e.features[0].properties
          document.getElementById(`place_${id}`).children[0].click()
        })
      });
    });
  }

  getLanguage() {
    return document.getElementsByName("i18n-lang")[0].dataset.lang;
  }

  iconUrl() {
    return window.location.origin + document.getElementsByName("icon-url")[0].dataset.path;
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
      is_shop: "shop"
    }
    const newGeoJson = {
      type: "geojson",
      data: {
        type: "FeatureCollection",
        features: []
      }
    }
    this.___g.data.features.forEach((f) => {
      const myTypes = Object.keys(f.properties).map((p) => f.properties[p] && legend[p] ? legend[p] : null).filter((p) => p);
      if (selectedTypes.find((t) => myTypes.includes(t))) {
        newGeoJson.data.features.push(f)
      }
    })
    this.removePlaceLayer()
    this.addPlaceLayer(newGeoJson)
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
    const map = this.map;
    map.addSource("point", geoJson);

    map.addLayer({
      id: "points",
      type: "symbol",
      source: "point", // reference the data source
      layout: {
        "icon-image": "icon", // reference the image
        "icon-size": 0.6,
        "icon-allow-overlap": true
      },
    });
  }

  removePlaceLayer() {
    this.map.removeLayer("points")
    this.map.removeSource("point")
  }

  markers() {
    return Array.from(document.getElementsByClassName("marker"));
  }

  async findMe() {
    if(this.userLocation) {
      this.flyToUser()
    } else {
      this.findMeTarget.children[0].classList.remove("hidden")
      await this.updateUserLocation();
      this.flyToUser();
    }
  }

  flyToUser() {
    if (!this.userLocation) throw new Error("Must create userLocation before calling flyToUser")
    this.map.flyTo({
      center: this.userLocation,
      zoom: 14,
    });
  }

  async nearestBeer() {
    const goToNearest = (closest) => {
      document.getElementById(`place_${closest.id}`).children[0].click();
      this.nearestBeerTarget.children[0].classList.add("hidden")
      this.map.flyTo({
        center: { lng: parseFloat(closest.lng), lat: parseFloat(closest.lat) },
        zoom: 14,
      });
    }
    if (this.userLocation) {
      goToNearest(this._nearestBeer(this.userLocation))
    } else {
      this.nearestBeerTarget.children[0].classList.remove("hidden")
      const location = await this.updateUserLocation();
      goToNearest(this._nearestBeer(location))
    }
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

  updateUserLocation() {
    return new Promise((resolve, reject) => {
      if (this.noGeolocation) {
        reject("noGeolocation")
      } else {
        const update = (position) => {
          this.userLocation = {
            lng: position.coords.longitude,
            lat: position.coords.latitude,
          };
          this.userHeading = position.coords.heading || 0;
          window.userLocation = this.userLocation;
          this.userLocationMarker.setLngLat(this.userLocation);
          this.userLocationTarget.style.transform = `rotate(${this.userHeading}deg)`
          this.userLocationTarget.classList.remove("hidden")
          this.findMeTarget.children[0].classList.add("hidden")
          resolve(this.userLocation);
        }
        navigator.geolocation.watchPosition(update)
      }
    });
  }
}

