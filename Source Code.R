qrm.backtest < - function(days = 252 * 5, d.r = 21, d.addv = 21,
    n.addv = 2000, inv.lvl = 2e+07, bnds = .01, incl.cost = F) {
    calc.ix < - function(i, d, d.r) {
        k1 < -d - i
        k1 < -trunc(k1 / d.r)
        ix < -d - k1 * d.r
        return (ix)
    }
    calc.mv.avg < - function(x, days, d.r) {
        y < -matrix(0, nrow(x), days)
        for (i in 1: days)
            y[, i] < -rowMeans(x[, i: (i + d.r - 1)])
        return (y)
    }
    calc.mv.sd < - function(x, days, d.r) {
        y < -matrix(0, nrow(x), days)
        for (i in 1: days)
            y[, i] < -apply(x[, i: (i + d.r - 1)], 1, sd)
        return (y)
    }
    read.x < - function(file) {
        x < -read.delim(file, as.is = T)
        x < -as.matrix(x)
        mode(x) < -"numeric"
        return (x)
    }
    calc.sharpe < - function(pnl, inv.lvl) {
        print(sum(pnl, na.rm = T))
        print(mean(pnl, na.rm = T) * 252 / inv.lvl * 100)
        print(mean(pnl, na.rm = T) / sd(pnl, na.rm = T) * sqrt(252))
    }
    ret < -read.x("nrm.ret.txt")
    open < -read.x("nrm.open.txt")
    close < -read.x("nrm.close.txt")
    vol < -read.x("nrm.vol.txt")
    prc < -read.x("nrm.prc.txt")
    addv < -calc.mv.avg(vol * close, days, d.addv)
    ret.close < -log(prc[, -ncol(prc)] / prc[, -1])
    tr < -calc.mv.sd(ret.close, days, d.r)
    ret < -ret[, 1: days]
    prc < -prc[, 1: days]
    close < -close[, 1: days]
    open < -open[, 1: days]
    close1 < -cbind(close[, 1], close[, -ncol(close)])
    open1 < -cbind(close[, 1], open[, -ncol(open)])
    pnl < -matrix(0, nrow(ret), ncol(ret))
    des.hold < -matrix(0, nrow(ret), ncol(ret))
    for (i in 1: ncol(ret)) {
        ix < -calc.ix(i, ncol(ret), d.r)
        if (i == 1)
            prev.ix < -0
        if (ix != prev.ix) {
            liq < -addv[, ix]
            x < -sort(liq) x < -x[length(x): 1]
            take < -liq >= x[n.addv]
            r1 < -ret.close[take, (ix: (ix + d.r - 1))]### ind.list < -qrm.stat.ind.class.all(r1, ###c(100, 30, 10), iter.max = 100)### rr < -qrm.gen.het(r1, ind.list)
            rr < -qrm.cov.pc(r1)### rr < -qrm.erank.pc(r1)
            cov.mat < -rr$inv.cov
            prev.ix < -ix
        }
        w.int < -rep(1, sum(take))
        ret.opt < -ret### DELAY - 0 MEAN - REVERSION### ret.opt < - -log(close / open)### DELAY - 1 MOMENTUM
        if (incl.cost) {
            lin.cost < -tr[take, i] / addv[take, i]
            lin.cost < -1e-3 * lin.cost / mean(lin.cost)
        } else
            lin.cost < -0
        ret.lin.cost < -ret.opt[take, i]
        ret.lin.cost < -sign(ret.lin.cost) *
            pmax(abs(ret.lin.cost) - lin.cost, 0)
        des.hold[take, i] < -as.vector(bopt.calc.opt(ret.lin.cost, w.int,
            cov.mat, bnds * liq[take] / inv.lvl, -bnds * liq[take] / inv.lvl))
        des.hold[take, i] < - -des.hold[take, i] *
            inv.lvl / sum(abs(des.hold[take, i]))
        pnl[take, i] < -des.hold[take, i] *
            (close1[take, i] / open1[take, i] - 1)
        pnl[take, i] < -pnl[take, i] - abs(des.hold[take, i]) * lin.cost
    }
    des.hold < -des.hold[, -1]
    pnl < -pnl[, -1]
    pnl < -colSums(pnl)
    calc.sharpe(pnl, inv.lvl)
    trd.vol < -2 * sum(abs(des.hold / open1[, -1]))
    cps < -100 * sum(pnl) / trd.vol
    print(cps)
}