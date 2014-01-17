(function() {
  define(["underscore", "model/configModel", "view/basicView"], function(_, config, basic) {
    return describe("basicView", function() {
      var bv;
      bv = new basic();
      before(function(done) {
        return config.fetch().done(function() {
          return done();
        });
      });
      describe("parseUrl", function() {
        it("ranking/#/year/2010n 長さ2", function() {
          var ret;
          ret = bv.parseUrl("/sp/enjoy/ranking/#/year/2010n");
          return expect(ret.length).to.be(2);
        });
        return it("ranking/#/year/2010n/ 長さ2", function() {
          var ret;
          ret = bv.parseUrl("/sp/enjoy/ranking/#/year/2010n/");
          return expect(ret.length).to.be(2);
        });
      });
      describe("numfy", function() {
        it("undefined だったら0を返す", function() {
          return expect(bv.numfy(void 0)).to.be("0");
        });
        return it("validだったらそのまま返す", function() {
          expect(bv.numfy("1")).to.be("1");
          return expect(bv.numfy(1)).to.be(1);
        });
      });
      return describe("isPaged", function() {
        it("2つのURLがページングか判定", function() {
          var ret;
          ret = bv.isPaged("#/year/1", "#/year/2");
          return expect(ret).to.be(true);
        });
        it("どちらかがページ数なし", function() {
          var ret;
          ret = bv.isPaged("#/year", "#/year/2");
          expect(ret).to.be(true);
          ret = bv.isPaged("#/year/", "#/year/2");
          expect(ret).to.be(true);
          ret = bv.isPaged("#/year/", "#/year/2/");
          return expect(ret).to.be(true);
        });
        it("ページ数がはなれている", function() {
          var ret;
          ret = bv.isPaged("#/year/11", "#/year/2");
          expect(ret).to.be(true);
          ret = bv.isPaged("#/year/11", "#/year/2/");
          return expect(ret).to.be(true);
        });
        return it("ページングでない場合", function() {
          var ret;
          ret = bv.isPaged("#/yeared/11", "#/year/2");
          return expect(ret).to.be(false);
        });
      });
    });
  });

}).call(this);
