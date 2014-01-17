define [
  "underscore"
  "model/configModel"
  "model/yearRankingModel"
  "model/searchModel"
  ], (_, config, rank, search) ->

    describe "configModel", ->
      before (done) ->
        config.fetch().done -> done()

      describe "getRandom メソッドは", ->

        it "指定件数のデータをランダムに返す", ->
          ret = config.getRandom "f", 12
          expect(ret.length).to.be 12
          ret2 = config.getRandom "f", 12
          expect(_.isEqual ret, ret2).to.be false

    describe "yearRankingModel", ->
      before (done) ->
        rank.fetch2("/sp/enjoy/ranking/data/n_2012").done -> done()

      describe "pagingメソッドは", ->
        it "指定された件数を返す", ->
          e_len = 10
          len = rank.paging(0,e_len,"m").length
          expect(len).to.be(e_len)

        it "指定された性別からなる配列を返す", ->
          ret = rank.paging(0, 10,"f")
          len = _.map(ret, (i)-> i.get "sex")
          len = _.uniq(len).length
          expect(len).to.be(1)

        it "指定されたオフセットからの配列を返す", ->
          ret = rank.paging(9, 1, "m")[0]
          expect(ret.get "name").to.be("龍生")

    describe "searchModel", ->
      before (done) ->
        config.fetch().done -> done()

      describe "searchName メソッドは ", ->

        it "名前を引数にとり、マッチする名前を返す", ->
          search.searchName "翔"
          #console.log search.models, search.models[0].get(0)
          expect( search.models.length ).to.be 45

      describe "searchYomi メソッドは ", ->

        it "読みを引数にとり、マッチするよみを返す", ->
          search.reset()
          search.searchYomi "ハルト"
          expect( search.models.length ).to.be 1

      describe "searchModel は ", ->

        it "search.reset で保持モデルをリセットする", ->
          search.reset()
          expect( search.models.length ).to.be 0

        it "名前、よみを検索するとモデルはリセットされず、たまっていく", ->
          search.searchYomi "ハ"
          search.searchYomi "ハ"
          search.searchYomi "ハ"
          expect( search.models.length ).to.be 48
