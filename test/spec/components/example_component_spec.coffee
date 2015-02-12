define [ 'jquery' ], ($) ->
  describeComponent 'office-hours/components/example_component', ->
    beforeEach ->
      fixture = readFixtures "example.html"
      @setupComponent(fixture)

    describe 'component', ->
      it 'should exist', ->
        expect(@component).toBeDefined()
