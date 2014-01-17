(function() {
  define(["underscore", "model/configModel", "model/yearRankingModel", "model/searchModel"], function(_, config, rank, search) {
    describe("configModel", function() {
      before(function(done) {
        return config.fetch().done(function() {
          return done();
        });
      });
      return describe("getRandom メソッドは", function() {
        return it("指定件数のデータをランダムに返す", function() {
          var ret, ret2;
          ret = config.getRandom("f", 12);
          expect(ret.length).to.be(12);
          ret2 = config.getRandom("f", 12);
          return expect(_.isEqual(ret, ret2)).to.be(false);
        });
      });
    });
    describe("yearRankingModel", function() {
      before(function(done) {
        return rank.fetch2("/sp/enjoy/ranking/data/n_2012").done(function() {
          return done();
        });
      });
      return describe("pagingメソッドは", function() {
        it("指定された件数を返す", function() {
          var e_len, len;
          e_len = 10;
          len = rank.paging(0, e_len, "m").length;
          return expect(len).to.be(e_len);
        });
        it("指定された性別からなる配列を返す", function() {
          var len, ret;
          ret = rank.paging(0, 10, "f");
          len = _.map(ret, function(i) {
            return i.get("sex");
          });
          len = _.uniq(len).length;
          return expect(len).to.be(1);
        });
        return it("指定されたオフセットからの配列を返す", function() {
          var ret;
          ret = rank.paging(9, 1, "m")[0];
          return expect(ret.get("name")).to.be("龍生");
        });
      });
    });
    return describe("searchModel", function() {
      before(function(done) {
        return config.fetch().done(function() {
          return done();
        });
      });
      describe("searchName メソッドは ", function() {
        return it("名前を引数にとり、マッチする名前を返す", function() {
          search.searchName("翔");
          return expect(search.models.length).to.be(45);
        });
      });
      describe("searchYomi メソッドは ", function() {
        return it("読みを引数にとり、マッチするよみを返す", function() {
          search.reset();
          search.searchYomi("ハルト");
          return expect(search.models.length).to.be(1);
        });
      });
      return describe("searchModel は ", function() {
        it("search.reset で保持モデルをリセットする", function() {
          search.reset();
          return expect(search.models.length).to.be(0);
        });
        return it("名前、よみを検索するとモデルはリセットされず、たまっていく", function() {
          search.searchYomi("ハ");
          search.searchYomi("ハ");
          search.searchYomi("ハ");
          return expect(search.models.length).to.be(48);
        });
      });
    });
  });

}).call(this);
