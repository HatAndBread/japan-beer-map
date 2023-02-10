export const showPopup = (e) => {
  const features = window.map.queryRenderedFeatures(e.point);
  if (features[0] && features[0].source === "point") {
    const translate = window.translate;
    const properties = features[0].properties;
    const coordinates = { lng: properties.lng, lat: properties.lat };
    markerDiv.dataset.id = properties.id;
    marker.setLngLat(coordinates);
    markerDiv.classList.remove("hidden");
    markerDiv.classList.add("z-10")
    markerDiv.innerHTML = `<span class="underline font-semibold">${properties.name}</span>`;
    const types = document.createElement("pre");
    types.className = "font-sans";
    types.innerText = `${translate("brewery")}: ${
      properties.is_brewery ? "🙆‍♀️" : "🙅‍♀️"
    }\n${translate("bottle_shop")}: ${
      properties.is_shop ? "🙆‍♀️" : "🙅‍♀️"
    }\n${translate("food")}: ${properties.has_food ? "🙆‍♀️" : "🙅‍♀️"}`;
    const instructions = document.createElement("div");
    instructions.innerText = window.translate("click_for_info");
    instructions.className = "text-sm text-gray-600";
    markerDiv.appendChild(types);
    markerDiv.appendChild(instructions);
    markerDiv.appendChild(triangle);
    if (Math.ceil(markerDiv.clientWidth) % 2) {
      markerDiv.style.width = (Math.ceil(markerDiv.clientWidth) + 1) + 'px'
    }
  }
};