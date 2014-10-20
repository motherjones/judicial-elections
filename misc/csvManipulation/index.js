// docs: http://www.adaltas.com/projects/node-csv/
var csv = require('csv');
var _ = require('underscore-node');

/*

-Total donated since 2000
-Average donation
-Top 5 recipients since 2000 (and amount)
-Top 5 donors since 2000 (and amount)
-Top 5 contributing industries since 2000 (and amount)
-Total lower-court contributions
-Top 5 lower court recipients (and amount)
-Top 5 lower court donors (and amount)
-Top 5 lower court donating industries (and amount)

*/

function average (arr)
{
  return _.reduce(arr, function(memo, num)
  {
    return memo + num;
  }, 0) / arr.length;
}

//read a file and use the first line to determine columns
csv().from.path("../data/PA.csv", {columns: true})
.to.array(function(data) {
  // now we have all the data as objects
  //console.log("data", data)

  var totalDonated = 0
  _.each(data, function(d,i){
    totalDonated = totalDonated + parseInt(d.Amount)
  })
  console.log("Total donated: ", totalDonated);


  var donations = _.map(data, function(row){ return parseInt(row['Amount']); })
  console.log("Average donation: ", average(donations))

  
  var topRecipients = _.sortBy(data, function(row){ return parseInt(row['Amount']) })
  console.log("topRecipients:", topRecipients[0]['RecipientName'], " + ", topRecipients[1]['RecipientName'], " + ", topRecipients[2]['RecipientName'], " + ", topRecipients[3]['RecipientName'], " + ", topRecipients[4]['RecipientName']);


  /*
  // write out two new csvs
  var cats = Object.keys(categories);
  cats.forEach(function(c) {
    // c is the name of the category
    // cat is the array
    var cat = categories[c];
    console.log("CAT", cat)
    csv().from.array(cat)
    .to.path(c + ".csv")
  })
*/

})

