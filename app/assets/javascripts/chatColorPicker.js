window.ColorPicker = new function() {
  this.palette = ["ED1898", "B788BD", "78AEFF", "1FDDFF", "D1FFF5"]

  this.getColor = function(){
    return this.palette[this.getRandomColorIndex()];
  };

  this.getRandomColorIndex = function(){
    return Math.round(Math.random() * ((this.palette.length -1) - 0) + 0);
  };
}