let lastHeading = 0;
export const useUserLocation = (callback) => {
  if (window.userLocation) return callback(window.userLocation);

  const options = {
    enableHighAccuracy: true,
    timeout: 1,
    maximumAge: 0
  };

  const loader = document.getElementById("map-loader");
  loader.classList.remove("hidden");
  navigator.geolocation.watchPosition(update, handleError, options);
  const interval = setInterval(() => {
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

    if (typeof position.coords.heading === "number") lastHeading = position.coords.heading;

    const locationMarkerElement = document.getElementById(
      "user-location-element"
    );
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
