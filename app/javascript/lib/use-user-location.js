let watchId;
let lastHeading = 0;
let notInJapan = false;

export const maxBounds = [
  [113, 20], // Southwest coordinates
  [154.74125158604622, 54.413834542307185], // Northeast coordinates
];

const isInJapan = () => {
  const {lng, lat} = window.userLocation;
  if (lng < maxBounds[0][0] || lng > maxBounds[1][0] || lat < maxBounds[0][1] || lat > maxBounds[1][1]) return false;
  return true;
}

export const useUserLocation = (callback) => {
  if (window.userLocation) return callback(window.userLocation);

  const options = {
    enableHighAccuracy: true,
    timeout: 9000,
    maximumAge: 0
  };

  const loader = document.getElementById("map-loader");
  loader.classList.remove("hidden");
  watchId = navigator.geolocation.watchPosition(update, handleError, options);
  const interval = setInterval(() => {
    if (notInJapan) clearInterval(interval);
    if (window.userLocation) {
      clearInterval(interval);
      loader.classList.add("hidden");
      callback(window.userLocation);
    }
  }, 10);
};

function handleError(e) {
  const el = document.getElementById("the-map-error");
  el.innerText = window.translate("map_error");
  console.log(e)
  el.classList.remove("hidden");
  document.getElementById("map-loader")?.classList?.add("hidden");
}

function update(position) {
  try {
    if (!window.map) {
      throw new Error("Beermap error: Attempted to update user location before map was initialized.")
    }

    window.userLocation = {
      lng: position.coords.longitude,
      lat: position.coords.latitude,
    };

    if (!isInJapan) {
      alert("You must be in Japan to use this feature.")
      notInJapan = true;
      return;
    }

    if (typeof position.coords.heading === "number") lastHeading = position.coords.heading;

    const locationMarkerElement = document.getElementById(
      "user-location-element"
    );
    window.locationMarkerElement = locationMarkerElement;
    if (!locationMarkerElement) return;

    locationMarkerElement.classList.remove("hidden");
    if (window.userLocationMarker) window.userLocationMarker.remove();

    window.userLocationMarker = new mapboxgl.Marker(locationMarkerElement)
      .setLngLat(window.userLocation)
      .addTo(window.map)
      .setRotation(lastHeading)
  } catch(e) {
    handleError(e)
  }
};

export const getWatchId = () => watchId;