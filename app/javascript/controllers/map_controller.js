import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["findMe"];
  connect() {
    const map = new mapboxgl.Map({
      container: "the-map",
      style: this.mapStyle(),
      center: [139.6503, 35.6762],
      zoom: 9,
    });
    this.map = map;

    this.addUserLocation();
    this.map.addControl(new mapboxgl.NavigationControl());
    if (!"geolocation" in navigator) {
      this.findMeTarget.remove();
      this.noGeolocation = true;
    }
    const geoJson = JSON.parse(this.geoJson());
    this.___g = geoJson;
    const iconUrl = this.iconUrl();
    map.on("load", () => {
      map.loadImage(iconUrl, (error, image) => {
        if (error) throw new Error(error)

        map.addImage("icon", image);

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
    console.log(newGeoJson)
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

  findMe() {
    if (this.findMeButton) {
      this.findMeButton.click();
    }
    this.updateUserLocation();
  }

  async nearestBeer() {
    const location = await this.updateUserLocation();
    const closest = this.markers().reduce(
      (prev, curr) => {
        const { lng, lat, id } = curr.children[0].dataset;
        const d = distance(lng, lat, location.lng, location.lat);
        if (d < prev.distance) return { distance: d, id, lng, lat };
        else return prev;
      },
      { distance: 99999, id: 99999, lng: 0, lat: 0 }
    );
    document.getElementById(`place_${closest.id}`).click();
    console.log(closest);
    this.map.flyTo({
      center: { lng: parseFloat(closest.lng), lat: parseFloat(closest.lat) },
      zoom: 14,
    });
  }

  updateUserLocation() {
    return new Promise((resolve, reject) => {
      if (this.noGeolocation) reject("noGeolocation");
      navigator.geolocation.getCurrentPosition((position) => {
        this.userLocation = {
          lng: position.coords.longitude,
          lat: position.coords.latitude,
        };
        window.userLocation = this.userLocation;
        resolve(this.userLocation);
      });
    });
  }

  addUserLocation() {
    this.map.addControl(
      new mapboxgl.GeolocateControl({
        positionOptions: {
          enableHighAccuracy: true,
        },
        // When active the map will receive updates to the device's location as it changes.
        trackUserLocation: true,
        // Draw an arrow next to the location dot to indicate which direction the device is heading.
        showUserHeading: true,
      })
    );
    const interval = setInterval(() => {
      const btn = document.querySelector(".mapboxgl-ctrl-geolocate");
      if (btn) {
        clearInterval(interval);
        this.findMeButton = btn;
      }
    });
  }
}

function distance(lat1, lon1, lat2, lon2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2 - lat1); // deg2rad below
  var dLon = deg2rad(lon2 - lon1);
  var a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(deg2rad(lat1)) *
      Math.cos(deg2rad(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c; // Distance in km
  return d;
}

function deg2rad(deg) {
  return deg * (Math.PI / 180);
}
