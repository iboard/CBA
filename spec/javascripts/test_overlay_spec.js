describe("Overlay div should be present"), function() {
  it("checks if div overlay can be set", function() {
    loadFixtures("index.html");
    $('#overlay').html('Hello Javascript');
    expect($('#overlay-content').html()).toEqual("Hello Javascript");
  });
});
