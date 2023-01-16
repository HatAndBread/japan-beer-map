const userLocation = () => {
  return new Promise((resolve, reject) => {
    if (window.noGeolocation) {
      reject("noGeolocation");
    } else {
      const update = (position) => {
        window.userLocation = {
          lng: position.coords.longitude,
          lat: position.coords.latitude,
        };
        window.userHeading = position.coords.heading || 0;
        this.userLocationMarker.setLngLat(this.userLocation);
        this.userLocationTarget.style.transform = `rotate(${this.userHeading}deg)`;
        this.userLocationTarget.classList.remove("hidden");
        this.findMeTarget.children[0].classList.add("hidden");
        resolve(this.userLocation);
      };
      navigator.geolocation.watchPosition(update);
    }
  });
};

export default userLocation;
