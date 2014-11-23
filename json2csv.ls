require! <[ fs async ]>


files = <[ r r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12  r13 r14 r15 r16 r17 r18 ]>


console.log "所得稅費用,稅前淨利,稅率,所得稅費用, 稅前淨利,稅率,所得稅費用, 稅前淨利,稅率,所得稅費用, 稅前淨利,稅率,所得稅費用, 稅前淨利,稅率,所得稅費用, 稅前淨利,稅率,所得稅費用, 稅前淨利,稅率,所得稅費用, 稅前淨利,稅率,所得稅費用, 稅前淨利,稅率"

function to-csv (filename)
  err, data <-fs.read-file 'json/' + filename + '.json'
  json = JSON.parse data.toString!
  j <- json.map
  tax = ''
  j.0.reverse!map (d,i) ->
    if i isnt j.0.length - 1
      tax += "\"#{d}\",\"#{j[1][j.0.length - 1 - i]}\",\"\","
    else
      tax += "\"#{d}\",\"#{j[1][j.0.length - 1 - i]}\",\"\""
  console.log tax

async.map files, to-csv
