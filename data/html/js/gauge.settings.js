var opts = {
  angle: 0.1,
  lineWidth: 0.2,
  font: "16px Arial",
  pointer: {
    length: 0.5,
    strokeWidth: 0.05,
    color: '#000000'
  },
staticLabels: {
  font: "16px Arial",
  color: "rgba(80,90,100,1)",
  labels: [{label:0, },
    {label:50},
    {label:70},
    {label:200},
    {label:250},
    {label:300,}],
  fractionDigits: 0
}, 
  staticZones: [
    {strokeStyle: "rgba(175,35,95,1)", min: 0, max: 50, height: 0.7},
    {strokeStyle: "rgba(235,210,10,1)", min: 50, max: 70, height: 0.7},
    {strokeStyle: "rgba(100,125,45,1)", min: 70, max: 200, height: 0.7},
    {strokeStyle: "rgba(235,210,10,1)", min: 200, max: 250, height: 0.7},
    {strokeStyle: "rgba(175,35,95,1)", min: 250, max: 300, height: 0.7}
  ],
  limitMax: false,
  limitMin: false,
  highDpiSupport: true
};