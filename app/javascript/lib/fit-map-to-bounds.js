export const fitMapToBounds = (sw, ne) => {
  if (!window.map) throw new Error("fitMapToBounds was called before map was initialized");

  //[number, number] southwestern corner of the bounds
  //[number, number] northeastern corner of the bounds
  window.map.fitBounds([sw, ne], {padding: 100});
};
