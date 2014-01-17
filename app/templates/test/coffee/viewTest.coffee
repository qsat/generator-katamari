define [
  "underscore"
  "model/configModel"
  "view/basicView"
  ], (_, config, basic) ->

    describe "basicView", ->

      bv = new basic()

      before (done) ->
        config.fetch().done -> done()

      describe "parseUrl", ->
        it "ranking/#/year/2010n 長さ2", ->
          ret = bv.parseUrl "/sp/enjoy/ranking/#/year/2010n"
          expect(ret.length).to.be 2

        it "ranking/#/year/2010n/ 長さ2", ->
          ret = bv.parseUrl "/sp/enjoy/ranking/#/year/2010n/"
          expect(ret.length).to.be 2

      describe "numfy", ->

        it "undefined だったら0を返す", ->
          expect( bv.numfy undefined ).to.be "0"

        it "validだったらそのまま返す", ->
          expect( bv.numfy "1" ).to.be "1"
          expect( bv.numfy 1 ).to.be 1

      describe "isPaged", ->

        it "2つのURLがページングか判定", ->
          ret = bv.isPaged "#/year/1", "#/year/2"
          expect(ret).to.be true

        it "どちらかがページ数なし", ->
          ret = bv.isPaged "#/year", "#/year/2"
          expect(ret).to.be true
          ret = bv.isPaged "#/year/", "#/year/2"
          expect(ret).to.be true
          ret = bv.isPaged "#/year/", "#/year/2/"
          expect(ret).to.be true

        it "ページ数がはなれている", ->
          ret = bv.isPaged "#/year/11", "#/year/2"
          expect(ret).to.be true
          ret = bv.isPaged "#/year/11", "#/year/2/"
          expect(ret).to.be true

        it "ページングでない場合", ->
          ret = bv.isPaged "#/yeared/11", "#/year/2"
          expect(ret).to.be false

