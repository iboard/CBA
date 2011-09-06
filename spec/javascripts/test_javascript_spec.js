describe("Strip blanks and dashes from strings", function() {
  it("cleans strings by removing spaces and dashes", function() {
    expect(CBAString.cleanString("123 4-5")).toEqual("12345");
  });
});
