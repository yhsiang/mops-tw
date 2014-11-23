require! <[ request cheerio async prelude-ls ]>
{concat, split-at} = require 'prelude-ls' .List
url = \http://mops.twse.com.tw/mops/web/ajax_t05st21

#co-id = [ 1763 1101 1102 1103 1104 1108 1109 ]
#co-id = [ 1110 2330 2454 2303 2311 3481 3673 ]
#co-id = [ 2409 2207 9904 9963 2354 2317 1328 ]
#co-id = [ 1216 1210 1402 2610 2603 2609 2618 ]
#co-id = [ 3045 2498 2412 2912 1326 1301 1304 ]
#co-id = [ 1305 1307 1308 1309 6505 1310 1312 ]
#co-id = [ 1313 1314 1315 1319 1321 1323 1324 ]
#co-id = [ 1325 1326 1337 1339 1340 1715 4306 ]
#co-id = [ 1303 2347 3702 2392 2308 2353 2352 ]
#co-id = [ 2382 2301 3231 2357 2356 2324 4938 ]

#co-id = [ 1605 2371 2105 1436 1438 1442 1805 ]
#co-id = [ 1808 2501 2504 2505 2506 2509 2511 ]
#co-id = [ 2515 2516 2520 2524 2527 2528 2530 ]
#co-id = [ 2534 2535 2536 2537 2538 2539 2540 ]
#co-id = [ 2542 2543 2545 2546 2547 2548 2597 ]
#co-id = [ 2841 2923 3052 3056 3703 5515 5519 ]
#co-id = [ 5521 5522 5525 5531 5533 5534 6177 ]
co-id = [ 9946 9957 2002 ]
years = [ 95 98 101 ]


function gen-years (co-id)
  years.map -> {id: co-id, year: it}



function fetch-data (options, next)
  {year, id} = options

  err, response, body <- request.post url, do
    form: do
      encodeURIComponent: 1
      step: 1
      firstin: 1
      off: 1
      queryName: 'co_id'
      t05st29_c_ifrs: 'N'
      t05st30_c_ifrs: 'N'
      TYPEK: 'all'
      isnew: false
      co_id: id
      year: year
  $ = cheerio.load body
  b4-tax = ($ 'table' .eq 4 .children 'tr' .eq 10 .children!map (i, it) -> return $ it .text!trim! if i isnt 0).to-array!
  after-tax = ($ 'table' .eq 4 .children 'tr' .eq 11 .children!map (i, it) -> return $ it .text!trim! if i isnt 0).to-array!
  if b4-tax.length is 0
    b4-tax = ($ 'table' .eq 5 .children 'tr' .eq 10 .children!map (i, it) -> return $ it .text!trim! if i isnt 0).to-array!
    after-tax = ($ 'table' .eq 5 .children 'tr' .eq 11 .children!map (i, it) -> return $ it .text!trim! if i isnt 0).to-array!
  next null, [b4-tax, after-tax]


function fetch-by-id (id, next)
  data = gen-years id
  err, results <- async.map data, fetch-data
  b4-tax = concat results.map (-> it.0 )
  after-tax = concat results.map (-> it.1 )
  next null, [b4-tax, after-tax]


err, r <- async.map co-id, fetch-by-id
console.log JSON.stringify r
