
create_chart = function(data) {
  //var config, data_container, headers;
  //data_container = $('.news-quote__ticker_active_true').attr('data-ticker');
  //headers = jQuery.parseJSON(data_container.attr('headers'));
  $('.news-quote__chart__canvas').innerHTML =''
  headers = 'курс'
  config = {
    element: 'news-quote__chart__canvas',
    data: data,
    xkey: 'x',
    ykeys: 'y',
    labels: 'x',
    resize: true,
    behaveLikeLine: true,
    parseTime: false
  };
  Morris.Bar(config);
};


Date.prototype.getTime = function () {
     return ((this.getHours() < 10)?"0":"") + this.getHours() +":"+ ((this.getMinutes() < 10)?"0":"") + this.getMinutes();
}


$( document ).ready(function() {


		//	google.load('visualization', '1.0', {'packages':['corechart']});

      // Set a callback to run when the Google Visualization API is loaded.
      //google.setOnLoadCallback(drawChart);
      	$('.news-quote__chart__canvas').attr('id','news-quote__chart__canvas')

        function a() {
            b(), c(), s.eq(0).trigger("click"), r.find(".js-tickers-chart__spinner").remove()
        }

        function b() {
            r = $(".js-tickers-chart:eq(0)"), s = $(".js-tickers-chart__ticker"), t = r.find(".js-tickers-chart__chart"), u = r.find(".js-tickers-chart__data-current"), v = r.find(".js-tickers-chart__x-crosshair"), w = $(".js-tickers-chart__no-data:eq(0)")
        }

        function c() {
            s.click(function() {
                s.removeClass(C), $(this).addClass(C);
                try {
                    y = JSON.parse($(this).attr("data-ticker"))
                } catch (a) {
                    return !1
                }

                var x = d(y)
                var m = p(x)
                x = v_(x,m)

                create_chart(x)
               // D = p(z)
                
                return z = d(y), D = p(z), z = o(z), 0 === z.length ? (w.find(".js-tickers-chart__no-data__ticker-name").text(y.display_name || ""), s.removeClass(C), r.hide(), void w.show()) : (r.show(), w.hide(), i(), e(), !1)
            })
            //), t.bind("plothover", $.throttle(30, function(a, b, c) {g(c)})
            //), t.bind("resize", $.debounce(500, i))
        }

        function d(a) {
            var b = [];
            if (!a || !a.items) return b;
            var c = a.items.length
            for (var d = 0; c > d; d++) {
                var e = a.items[c-d-1];
                b.push([new Date(e.time).getTime(), e.value])
                //b.push({'x':new Date(e.time).getTime(), 'y':e.value})
                //b.push(new Date(e.time).getTime())
            }
            return b
        }

        function v_(a,m) {
            var b = [];
           // if (!a || !a.items) return b;
            for (var c = a.length, d = 0; c > d; d++) {
                var e = a[d];                
                b.push({'x':e[0], 'y':e[1]-m.min,'h':e[1] })
            }
            return b
        }

        function e() {
            var a = $("." + C).position().top,
                b = t.parents(".l-row:eq(0)").eq(0),
                c = b.height(),
                d = t.parent().parent().outerHeight(),
                e = a;
            a + d >= c && (e = c - d), t.parent().parent().stop().animate({
                top: e
            }, 200)
        }

        function f(a) {
            if (!a) return "";
            var b = new Date(a),
                c = function(a) {
                    return 10 > a ? "0" + a : a
                };
            return b.getHours() + ":" + c(b.getMinutes())
        }

        function g(a) {
            if (a && a.datapoint) {
                var b = f(a.datapoint[0]),
                    c = h(a),
                    d = parseInt(v.parent().css("padding-top"), 10);
                v.css({
                    top: c.top + d
                }), x.draw(), u.html([b, "<br/>", a.datapoint[1]].join("")), u.css({
                    top: c.top + d - B / 2
                })
            }
        }

        function h(a) {
            return x.lockCrosshair({
                x: a.datapoint[0] - A / 2,
                y: a.datapoint[1]
            }), x.pointOffset({
                x: a.datapoint[0],
                y: a.datapoint[1]
            })
        }

        function i() {
            var a = {
                grid: {
                    borderWidth: 0,
                    borderColor: null,
                    minBorderMargin: null,
                    labelMargin: 5,
                    axisMargin: 0,
                    aboveData: !1,
                    hoverable: !0
                },
                highlightColor: "#009f8b",
                bars: {
                    show: !0,
                    horizontal: !1,
                    barWidth: A,
                    fill: !0,
                    fillColor: {
                        colors: ["rgba(0,159,139,0.9)", "rgba(213,253,227,0.9)"]
                    },
                    align: "left",
                    lineWidth: 0,
                    order: 10
                },
                xaxis: {
                    mode: "time",
                    timeformat: "%h:%M",
                    tickLength: 0,
                    tickFormatter: function(a) {
                        return f(a)
                    }
                },
                yaxis: {
                    min: D.min - D.diff / 4,
                    max: D.max + D.diff / 4,
                    tickLength: 0,
                    labelWidth: 0,
                    tickFormatter: function() {
                        return ""
                    }
                }
            };
            x = t.plot([{
                data: z
            }], a).data("plot"), j(), k(), l(), m(), g(n(z[0]))
        }

        function j() {
            var a = "GMT+3:00";
            r.find(".js-tickers-chart__gmt").text(a)
        }

        function k() {
            var a = r.find(".js-tickers-chart__mark-max").add(r.find(".js-tickers-chart__mark-min")).add(r.find(".js-tickers-chart__data-max")).add(r.find(".js-tickers-chart__data-min"));
            z && z[D.maxIndex][1] === z[D.minIndex][1] ? a.hide() : a.show()
        }

        function l() {
            if (z) {
                var a = parseInt(v.parent().css("padding-top"), 10),
                    b = h(n(z[D.maxIndex]));
                r.find(".js-tickers-chart__mark-max").css({
                    top: b.top + a
                }), r.find(".js-tickers-chart__data-max").html("Макс.<br/>" + z[D.maxIndex][1]).css({
                    top: b.top + a - B + 4
                })
            }
        }

        function m() {
            if (z) {
                var a = parseInt(v.parent().css("padding-top"), 10),
                    b = h(n(z[D.minIndex]));
                r.find(".js-tickers-chart__mark-min").css({
                    top: b.top + a
                }), r.find(".js-tickers-chart__data-min").html("Мин.<br/>" + z[D.minIndex][1]).css({
                    top: b.top + a
                })
            }
        }

        function n(a) {
            return {
                datapoint: [a[0], a[1], 0]
            }
        }

        function o(a) {
            var b = 34,
                c = a.length,
                d = a[c - 1] && a[c - 1][0],
                e = b - c;
            if (c >= b || !d) return a;
            for (var f = 0; e > f; f++) d += 9e5, a.push([d, 0]);
            return a
        }

        function p(a) {
            for (var b, c, d, e, f, g = [], h = a.length, i = 0; h > i; i++) g.push(a[i][1] / 1);
            return b = q(g, "max"), c = q(g, "min"), d = g[b], e = g[c], f = d - e, 0 === f && (f = .95 * d), {
                max: d,
                min: e,
                maxIndex: b,
                minIndex: c,
                diff: f
            }
        }

        function q(a, b) {
            for (var c = a[0], d = 0, e = !1, f = 1; f < a.length; f++) e = "max" === b ? e = a[f] > c : a[f] < c, e === !0 && (c = a[f], d = f);
            return d
        }
        var r, s, t, u, v, w, x, y, z, A = 96e4,
            B = 38,
            C = "news-quote__ticker_active_true",
            D = {};
        a()
   
});