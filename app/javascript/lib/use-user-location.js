
export const useUserLocation = (callback) => {
  if (window.userLocation) return callback(window.userLocation);

  const options = {
    enableHighAccuracy: true,
    timeout: 5000,
    maximumAge: 0
  };

  const loader = document.getElementById("map-loader");
  loader.classList.remove("hidden");
  navigator.geolocation.watchPosition(update, error, options);
  const interval = setInterval(() => {
    if (window.userLocation) {
      clearInterval(interval);
      loader.classList.add("hidden");
      callback(window.userLocation);
    }
  }, 10);
};

function update(position) {
  if (!window.map) {
    throw new error("Beermap error: Attempted to update user location before map was initialized.")
  }

  window.userLocation = {
    lng: position.coords.longitude,
    lat: position.coords.latitude,
  };
  console.log(position)
  document.body.prepend(JSON.stringify(position.coords.heading))
  window.userHeading = position.coords.heading || 0;

  const locationMarkerElement = document.getElementById(
    "user-location-element"
  );
  if (!locationMarkerElement) return;

  locationMarkerElement.classList.remove("hidden");
  if (window.userLocationMarker) window.userLocationMarker.remove();

  window.userLocationMarker = new mapboxgl.Marker(locationMarkerElement)
    .setLngLat(window.userLocation)
    .addTo(window.map)
    .setRotation(window.userHeading)
};

function error(e) {
  console.error(e);
}
