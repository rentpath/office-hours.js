define [
  'jquery'
  'office-hours/example'
], (
  $
  Example
) ->

  describe "example", ->
    it "should set the param when given one", () ->
      example = new Example(1)
      expect(example.param).toBe(1)
