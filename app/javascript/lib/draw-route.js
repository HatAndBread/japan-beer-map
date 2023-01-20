export const drawRoute = (geojson) => {
  if (!window.map)
    throw new Error("Draw route called before map was initialized.");

  const { map } = window;

  if (map.getSource("route")) {
    map.getSource("route").setData(geojson);
  } else {
    map.addLayer({
      id: "route",
      type: "line",
      source: {
        type: "geojson",
        data: geojson,
      },
      layout: {
        "line-join": "round",
        "line-cap": "round",
      },
      paint: {
        "line-color": "#4f46e5",
        "line-width": 5,
        "line-opacity": 0.75,
      },
    });
  }
};
