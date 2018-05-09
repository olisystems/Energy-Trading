//OLIOrigin Contract
var contract_origin_address = "0x3a9c865ff25ddaa0901dd6abe68b92f7a6b151fe";
var contract_origin_abi = [{"constant":true,"inputs":[{"name":"_account","type":"address"}],"name":"get_oliType","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_account","type":"address"}],"name":"get_oliCkt","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_account","type":"address"}],"name":"get_oliTrafoid","outputs":[{"name":"","type":"uint32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_tid","type":"uint32"}],"name":"get_gsoAddr","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_account","type":"address"},{"name":"_index","type":"uint8"}],"name":"get_oliPeakLoad","outputs":[{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"oli","type":"address"},{"name":"lat","type":"uint32"},{"name":"long","type":"uint32"},{"name":"trafo","type":"uint32"},{"name":"ckt","type":"uint8"},{"name":"typex","type":"uint8"},{"name":"pload","type":"uint16[]"}],"name":"addOli","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"paymentAddress","type":"address"},{"indexed":false,"name":"latOfLocation","type":"uint32"},{"indexed":false,"name":"longOfLocation","type":"uint32"}],"name":"newAddedOli","type":"event"}];
//OLICOin contract
var contract_Coin_address = "0xdb0f919b72c20948e6c6c06c1280c7aed3a48b51";
var contract_Coin_abi = [{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"caddress","type":"address"}],"name":"get_coinBalance","outputs":[{"name":"","type":"int32"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_contract","type":"address"},{"name":"_tf","type":"bool"}],"name":"set_ContractAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_account","type":"address"},{"name":"_change","type":"int32"}],"name":"set_OliCoinBalance","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint16"}],"name":"transfer","outputs":[{"name":"success","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint16"}],"name":"Transfer","type":"event"}];
//OLIDaughter contract
var contract_daughter_address = "0xced60ac716aabcc6ee9aff2d0982cb5e29371d51";
var contract_daughter_abi = [{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setOliOrigin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_amount","type":"uint16"},{"name":"_rate","type":"uint8"}],"name":"bid","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setBilateralTrading","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setOliCoin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setDynamicGridFee","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"resett","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"get_producer","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_rate","type":"uint8"}],"name":"get_sRate","outputs":[{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"get_consumer","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_rate","type":"uint8"}],"name":"get_dRate","outputs":[{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"maxRate","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"breakEven","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"gaddr","type":"address"},{"indexed":false,"name":"grate","type":"uint8"},{"indexed":false,"name":"gamount","type":"uint16"}],"name":"NewGenBid","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"caddr","type":"address"},{"indexed":false,"name":"crate","type":"uint8"},{"indexed":false,"name":"camount","type":"uint16"}],"name":"NewConBid","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"cbid","type":"uint8"}],"name":"NewMcp","type":"event"}];
//Bilateral Trade contract
var contract_bilateral_address = "0x1304209854905c947f2ce1140eac577301c1baee";
var contract_bilateral_abi = [{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setOliOrigin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_stock","type":"address"},{"name":"_rate","type":"uint8"}],"name":"stockBidding","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_stock","type":"address"}],"name":"get_stockAmount","outputs":[{"name":"","type":"uint16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_amount","type":"uint16"},{"name":"_rate","type":"uint8"},{"name":"_period","type":"uint32"},{"name":"_btime","type":"uint32"}],"name":"regStock","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_stock","type":"address"}],"name":"get_stockBidder","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_stock","type":"address"}],"name":"get_stockRate","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"saccount","type":"address"},{"indexed":false,"name":"samount","type":"uint16"},{"indexed":false,"name":"smrate","type":"uint8"},{"indexed":false,"name":"speriod","type":"uint32"},{"indexed":false,"name":"sbiddingTime","type":"uint32"}],"name":"NewStock","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"baccount","type":"address"},{"indexed":false,"name":"bmrate","type":"uint8"}],"name":"NewStockBid","type":"event"}];
//Grid Fee Contract
var contract_gridFee_address = "0x46bfeab0556ac1ae91c60f302d146712b9df50b4";
var contract_gridFee_abi = [{"constant":true,"inputs":[{"name":"_tid","type":"uint32"},{"name":"_index","type":"uint8"}],"name":"get_gridFee","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_amount","type":"uint16"}],"name":"set_trafocamount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"addr","type":"address"}],"name":"setOliOrigin","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_amount","type":"uint16"}],"name":"set_cktcamount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_tid","type":"uint32"}],"name":"set_tgridFee","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_tid","type":"uint32"},{"name":"_index","type":"uint8"}],"name":"get_cktAmount","outputs":[{"name":"","type":"int16"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"get_tGFee","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_address","type":"address"},{"name":"_fee","type":"uint8[]"}],"name":"set_minmaxgfee","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_amount","type":"uint16"}],"name":"set_traforamount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"get_dGFee","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_tid","type":"uint32"}],"name":"set_dgridFee","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_amount","type":"uint64"}],"name":"set_cktramount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"get_trafoAmount","outputs":[{"name":"","type":"int16"}],"payable":false,"stateMutability":"view","type":"function"}];
if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
} else {
  // set the provider you want from Web3.providers
  web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
var contract_origin_instance = web3.eth.contract(contract_origin_abi).at(contract_origin_address);
var contract_Coin_instance = web3.eth.contract(contract_Coin_abi).at(contract_Coin_address);
var contract_daughter_instance = web3.eth.contract(contract_daughter_abi).at(contract_daughter_address);
var contract_bilateral_instance = web3.eth.contract(contract_bilateral_abi).at(contract_bilateral_address);
var contract_gridFee_instance = web3.eth.contract(contract_gridFee_abi).at(contract_gridFee_address);
var myEvent;
var trafo_id;
var circuit = ['First', 'Second'];
var circuit_index;
var p_type = ['PV', 'Wind', 'CCP', 'CHP', 'Coal', 'Battery', 'Battery', 'Consumer', 'DNO'];
var p_type_index;
var peak;
var traf_aray = [];
var regStock;
var stockBid;

function nowTime() {
  var info = web3.eth.getBlock('latest');
  var date = new Date((info.timestamp) * 1000);
  // Hours part from the timestamp
  var hours = date.getHours();
  // Minutes part from the timestamp
  var minutes = "0" + date.getMinutes();
  // Seconds part from the timestamp
  var seconds = "0" + date.getSeconds();
  // Will display time in 10:30:23 format
  var formattedTime = hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2);
  return formattedTime;
}

function watchNewAddedOlis() {
  myEvent = contract_origin_instance.newAddedOli({
    fromBlock: 'latest',
    toBlock: 'latest'
  });
  console.log(myEvent);
  myEvent.watch(function (error, result) {
    if (error) {
      console.log(error);
    } else {
      console.log(result);
      trafo_id = contract_origin_instance.get_oliTrafoid(result.args.paymentAddress);
      circuit_index = parseInt(contract_origin_instance.get_oliCkt(result.args.paymentAddress));
      p_type_index = parseInt(contract_origin_instance.get_oliType(result.args.paymentAddress));
      if (p_type_index == 8) {
        for (a = 0; a <= circuit_index; a++) {
          traf_aray.push(parseInt(contract_origin_instance.get_oliPeakLoad(result.args.paymentAddress, parseInt(a))));
        }
        document.getElementById("gso").innerHTML += "<br />" + "<br />" +
          "Oli Payment Address: " + result.args.paymentAddress + " | Oli GPS Coordinates: (" + ((result.args.latOfLocation) / 10000) + "," +
          ((result.args.longOfLocation) / 10000) + ") | Transformer ID: " + trafo_id + " | Circuits: " + circuit_index +
          " | Agent Type: " + p_type[p_type_index] + " | Transformer Power: " + traf_aray[0] + " | Circuit Capacity: " + traf_aray.slice(1);
        traf_aray = [];
      } else {
        peak = parseInt(contract_origin_instance.get_oliPeakLoad(result.args.paymentAddress, parseInt(0)));
        document.getElementById("events_n").innerHTML += "<br />" + "<br />" +
          "Oli Payment Address: " + result.args.paymentAddress + " | Oli GPS Coordinates: (" + ((result.args.latOfLocation) / 10000) + "," +
          ((result.args.longOfLocation) / 10000) + ") | Transformer ID: " + trafo_id + " | Circuit: " + circuit[circuit_index] +
          " | Connection Type: " + p_type[p_type_index] + " | Peak Power: " + peak;
      }
    }
  });
};

var header = new Array();
header.push(["Eth Address", 'Coordinates [Lat-Long]', 'Transformer Id', 'Device Type', 'Peak Power [W]']);

function getAllAddedOlis() {
  contract_origin_instance.newAddedOli({}, {
    fromBlock: 0,
    toBlock: 'latest'
  }).get(function (error, result) {
    if (error) {
      console.error(error);
    } else {

      // declaring empty arrays to dynamically store the values
      var address = [];
      var coordinates = [];
      var transformerId = [];
      var circuit = [];
      var connection = [];
      var peakPower = [];
      var markers = [];
      var lat2 = [];
      var long2 = [];

      //console.log(result);
      for (i = 0; i < result.length; i++) {
        trafo_id = contract_origin_instance.get_oliTrafoid(result[i].args.paymentAddress);
        circuit_index = parseInt(contract_origin_instance.get_oliCkt(result[i].args.paymentAddress));
        p_type_index = parseInt(contract_origin_instance.get_oliType(result[i].args.paymentAddress));
        peak = parseInt(contract_origin_instance.get_oliPeakLoad(result[i].args.paymentAddress, parseInt(0)));

        address.push(result[i].args.paymentAddress);
        coordinates.push((result[i].args.latOfLocation) / 10000 + ' ' + (result[i].args.longOfLocation) / 10000);
        transformerId.push(trafo_id);
        circuit.push(circuit[circuit_index]);
        connection.push(p_type[p_type_index]);
        peakPower.push(peak);
        lat2.push((result[i].args.latOfLocation) / 10000);
        long2.push((result[i].args.longOfLocation) / 10000);
        markers.push((result[i].args.latOfLocation) / 10000 + ', ' + (result[i].args.longOfLocation) / 10000);

      }
      // table starts from here

      for (var i = 0; i < address.length; i++) {
        header.push([address[i], coordinates[i], transformerId[i], connection[i], peakPower[i]]);
      }

      //Create a HTML Table element.
      var table = document.createElement("Table");
      table.style.cssText = 'table-layout: fixed;  width: 100%; font-size: 12px; word-break: break-word:display: block;';

      //Get the count of columns.
      var columnCount = header[0].length;

      //Add the header row.
      var row = table.insertRow(-1);

      for (var i = 0; i < columnCount; i++) {
        var headerCell = document.createElement("TH");
        headerCell.innerHTML = header[0][i];
        row.appendChild(headerCell);
      }

      //Add the data rows.
      for (var i = 1; i < header.length; i++) {
        row = table.insertRow(-1);
        for (var j = 0; j < columnCount; j++) {
          var cell = row.insertCell(-1);
          cell.style.cssText = 'white-space: nowrap; text-overflow:ellipsis; overflow: hidden; max-width:1px;';
          cell.innerHTML = header[i][j];
        }
      }

      var rigisteredOliTable = document.getElementById("getAllAddedOlisTable");
      rigisteredOliTable.innerHTML = "";
      rigisteredOliTable.appendChild(table);

      var map = L.map('map').setView([48.77538056, 9.16277778], 14);
      mapLink =
        '<a href="http://openstreetmap.org">OpenStreetMap</a>';
      L.tileLayer(
        'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
          attribution: '&copy; ' + mapLink + ' Contributors',
          maxZoom: 10,
        }).addTo(map);

      var marker = L.marker([48.77538056, 9.16277778]).addTo(map);
      marker.bindPopup("OLI Systems GmbH");
      marker.on('mouseover', function (e) {
        this.openPopup();
      });
      marker.on('mouseout', function (e) {
        this.closePopup();
      });

      //for (var i = 0; i < long2.length; i++) {
      for (var i = 0; i < lat2.length; i++) {

        var lon = long2[i];
        var lat = lat2[i];
        var popupText = "Oli Payment Address: " + result[i].args.paymentAddress + " | Oli GPS Coordinates: (" + ((result[i].args.latOfLocation) / 10000) + "," + ((result[i].args.longOfLocation) / 10000) + ") | Transformer ID: " + trafo_id + " | Device Type: " + connection[i] + " | Peak Power: " + peak;

        var markerLocation = new L.LatLng(lat, lon);
        var marker = new L.Marker(markerLocation);
        map.addLayer(marker);
        marker.bindPopup(popupText);
      }

    }
  });
}

// stop watch start here

class OliClock {
  constructor(display, oliResults) {
    this.running = false;
    this.display = display;
    this.oliResults = oliResults;
    this.laps = [];
    this.resetClock();
    this.print(this.times);
  }

  resetClock() {
    this.times = [0, 0, 0];
  };

  startClock() {
    if (!this.time) this.time = performance.now();
    if (!this.running) {
      this.running = true;
      requestAnimationFrame(this.step.bind(this));
    }
  };

  lapClock() {
    let times = this.times;
    document.getElementById("testID").innerHTML = "Time elapsed for last transaction: " + this.format(times);

  }

  stopClock() {
    this.running = false;
    this.time = null;
  }

  restartClock() {
    if (!this.time) this.time = performance.now();
    if (!this.running) {
      this.running = true;
      requestAnimationFrame(this.step.bind(this));
    }
    this.resetClock();
  }

  clear() {
    clearChildren(this.oliResults);
  }

  step(timestamp) {
    if (!this.running) return;
    this.calculate(timestamp);
    this.time = timestamp;
    this.print();
    requestAnimationFrame(this.step.bind(this));
  }

  calculate(timestamp) {
    var diff = timestamp - this.time;
    // Hundredths of a second are 100 ms
    this.times[2] += diff / 10;
    // Seconds are 100 hundredths of a second
    if (this.times[2] >= 100) {
      this.times[1] += 1;
      this.times[2] -= 100;
    }
    // Minutes are 60 seconds
    if (this.times[1] >= 60) {
      this.times[0] += 1;
      this.times[1] -= 60;
    }
  }

  print() {
    this.display.innerText = this.format(this.times);
  }

  format(times) {
    return `\
${pad0(times[0], 2)}:\
${pad0(times[1], 2)}:\
${pad0(Math.floor(times[2]), 2)}`;
  }
}

function pad0(value, count) {
  var result = value.toString();
  for (; result.length < count; --count)
    result = '0' + result;
  return result;
}

function clearChildren(node) {
  while (node.lastChild)
    node.removeChild(node.lastChild);
}

let oliClock = new OliClock(
  document.querySelector('.oliClock'),
  document.querySelector('.oliResults'));

var mcp;
var cycle = [];
var runn = 0;
var ckt;

var cBid = [];
var currentTime = [];

function watchMCP() {

  mcp = contract_daughter_instance.NewMcp({
    fromBlock: 'latest',
    toBlock: 'latest'
  });
  mcp.watch(function (error, result) {
    if (error) {
      console.log(error);
    } else {

      // slicing last five values
      cBid.push(result.args.cbid.c[0]);
      currentTime.push(nowTime());

      if (cBid.length > 10) {
        cBid = cBid.slice(-10);
        currentTime = currentTime.slice(-10);
      }

      var data = [{
        x: currentTime,
        y: cBid,
        type: 'scatter'
      }];

      var timeSeriesGraphLayout = {
        xaxis: {
          title: 'Time',
          showline: true,
          linecolor: 'lightgray',
          linewidth: 0.5,
          titlefont: {
            color: 'black'
          }
        },
        yaxis: {
          title: 'Price [ct/kWh]',
          showline: true,
          linecolor: 'lightgray',
          linewidth: 0.5,
          titlefont: {
            color: 'black'
          },
        },
        margin: {
          l: 50,
          r: 15,
          b: 150,
          t: 15,
          pad: 4
        }
      };

      Plotly.newPlot('mcp', data, timeSeriesGraphLayout);
      oliClock.lapClock();
      oliClock.restartClock();

    }

  });
};

var pbid;
var gamt;
var header2 = [];
header2.push(["Eth Address", 'Price [ct/kWh]', 'Power [W]']);
var xProducerRate = [];
var yProducerAmount = [];

function watchpbid() {

  pbid = contract_daughter_instance.NewGenBid({
    fromBlock: 'latest',
    toBlock: 'latest'
  });
  pbid.watch(function (error, result) {
    if (error) {
      console.log(error);
    } else {

      var tmpSum = 0;
      if (xProducerRate.length > 5) {
        xProducerRate.push(result.args.grate.c[0]);
        yProducerAmount.push(result.args.gamount.c[0]);
        xProducerRate = xProducerRate.slice(-5);
        yProducerAmount = yProducerAmount.slice(-5);
      } else {
        xProducerRate.push(result.args.grate.c[0]);
        yProducerAmount.push(result.args.gamount.c[0]);
      };

      var producerRate = [],
        producerAmount = [];

      // creating single sorted object
      var outputObject = {};
      xProducerRate.forEach((key, i) => outputObject[key] = yProducerAmount[i]);

      // conveting object into single arrays
      for (var property in outputObject) {
        if (!outputObject.hasOwnProperty(property)) {
          continue;
        }
        producerRate.push(parseInt(property));
        producerAmount.push(outputObject[property]);
      }

      // replacing the original values
      xProducerRate = producerRate;
      yProducerAmount = producerAmount;

      // Accumulate the amounts for plotly x - axis array
      var plotAmountAccum = [];
      for (i = 0; i < yProducerAmount.length; i++) {
        tmpSum = tmpSum + yProducerAmount[i];
        plotAmountAccum.push(tmpSum);
      };
      var tmpRateLength = xProducerRate.length * -1;

      plotAmountAccum = plotAmountAccum.slice(tmpRateLength);

      // table starts from here
      header2.push([result.args.gaddr, result.args.grate, result.args.gamount]);

      if (header2.length > 6) {
        header2 = header2.slice(-5);
        header2.splice(0, 0, ["Eth Address", 'Price [ct/kWh]', 'Power [W]']);
      };

      //Create a HTML Table element.
      var table2 = document.createElement("Table");
      table2.style.cssText = 'table-layout: fixed;  width: 100%; font-size: 12px; word-break: break-word;';

      //Get the count of columns.
      var columnCount = header2[0].length;

      //Add the header row.
      var row = table2.insertRow(-1);
      for (var i = 0; i < columnCount; i++) {
        var header2Cell = document.createElement("TH");
        header2Cell.innerHTML = header2[0][i];
        row.appendChild(header2Cell);
      }

      //Add the data rows.
      for (var i = 1; i < header2.length; i++) {
        row = table2.insertRow(-1);
        for (var j = 0; j < columnCount; j++) {
          var cell = row.insertCell(-1);
          cell.style.cssText = 'white-space: nowrap; text-overflow:ellipsis; overflow: hidden; max-width:1px;';
          cell.innerHTML = header2[i][j];
        }
      }

      var dvTable = document.getElementById("pbid");
      dvTable.innerHTML = "";
      dvTable.appendChild(table2);

      // reinitialize plotly data object:
      producerBid.x = plotAmountAccum;
      producerBid.y = xProducerRate;
      biddata = [producerBid, consumerBid];

      newBidGraph();
    }
  });
};

var cbid;
var header1 = [];
header1.push(["Eth Address", 'Price [ct/kWh]', 'Power [W]']);
var xConsumerRate = [];
var yConsumerAmount = [];

function watchcbid() {
  cbid = contract_daughter_instance.NewConBid({
    fromBlock: 'latest',
    toBlock: 'latest'
  });
  cbid.watch(function (error, result) {
    if (error) {
      console.log(error);
    } else {

      var tmpSum = 0;
      if (xConsumerRate.length > 5) {
        xConsumerRate.push(result.args.crate.c[0]);
        yConsumerAmount.push(result.args.camount.c[0]);
        xConsumerRate = xConsumerRate.slice(-5);
        yConsumerAmount = yConsumerAmount.slice(-5);
      } else {
        xConsumerRate.push(result.args.crate.c[0]);
        yConsumerAmount.push(result.args.camount.c[0]);
      };

      var consumerRate = [],
        consumerAmount = [];
      // creating single sorted object
      var outputObject = {};
      xConsumerRate.forEach((key, i) => outputObject[key] = yConsumerAmount[i]);
      // decending order function
      var keys = Object.keys(outputObject);
      keys.sort(function (a, b) {
        return b - a;
      });
      // Iterate through the array of keys and access the corresponding object properties
      for (var i = 0; i < keys.length; i++) {
        consumerRate.push(parseInt(keys[i]));
        consumerAmount.push(outputObject[keys[i]]);
      };

      // replacing the original values
      xConsumerRate = consumerRate;
      yConsumerAmount = consumerAmount;

      // Accumulate the amounts for plotly x - axis array
      var plotAmountAccum = [];
      for (i = 0; i < yConsumerAmount.length; i++) {
        tmpSum = tmpSum + yConsumerAmount[i];
        plotAmountAccum.push(tmpSum);
      };
      var tmpRateLength = xConsumerRate.length * -1;

      plotAmountAccum = plotAmountAccum.slice(tmpRateLength);

      // table starts from here
      header1.push([result.args.caddr, result.args.crate, result.args.camount]);
      if (header1.length > 6) {
        header1 = header1.slice(-5);
        header1.splice(0, 0, ["Eth Address", 'Price [ct/kWh]', 'Power [W]']);
      };
      //Create a HTML Table element.
      var table1 = document.createElement("Table");
      table1.style.cssText = 'table-layout: fixed;  width: 100%; font-size: 12px; word-break: break-word;';

      //Get the count of columns.
      var columnCount = header1[0].length;

      //Add the header row.
      var row = table1.insertRow(-1);
      for (var i = 0; i < columnCount; i++) {
        var header1Cell = document.createElement("TH");
        header1Cell.innerHTML = header1[0][i];
        row.appendChild(header1Cell);
      }

      //Add the data rows.
      for (var i = 1; i < header1.length; i++) {
        row = table1.insertRow(-1);
        for (var j = 0; j < columnCount; j++) {
          var cell = row.insertCell(-1);
          cell.style.cssText = 'white-space: nowrap; text-overflow:ellipsis; overflow: hidden; max-width:1px;';
          cell.innerHTML = header1[i][j];
        }
      }

      var dvTable = document.getElementById("cbid");
      dvTable.innerHTML = "";
      dvTable.appendChild(table1);

      // reinitialize plotly data object:
      consumerBid.x = plotAmountAccum;
      consumerBid.y = xConsumerRate;
      biddata = [producerBid, consumerBid];
      newBidGraph();
    }
  });
}

//Merit Order Graph

var producerBid = {
  x: yProducerAmount,
  y: xProducerRate,
  mode: 'lines+markers',
  name: 'Producer',
  line: {
    shape: 'vh'
  },
  type: 'scatter'
};

var consumerBid = {
  x: yConsumerAmount,
  y: xConsumerRate,
  mode: 'lines+markers',
  name: 'Consumer',
  line: {
    shape: 'vh'
  },
  type: 'scatter'
};
var biddata = [producerBid, consumerBid];
var layout3 = {
  xaxis: {
    title: 'Power [W]',
    tickformat: "none",
    showline: true,
    linecolor: 'lightgray',
    linewidth: 0.5,
    titlefont: {
      color: 'black',
      weight: 'bold'
    }
  },
  yaxis: {
    title: 'Price [‎ct/kWh]',
    showline: true,
    linecolor: 'lightgray',
    linewidth: 0.5,
    titlefont: {
      color: 'black',
      weight: 'bold'
    }
  },
  margin: {
    l: 55,
    r: 15,
    b: 150,
    t: 15,
    pad: 4
  }
};

function newBidGraph() {
  Plotly.newPlot('moa', biddata, layout3);
}

function timeConverter(UNIX_timestamp) {
  var a = new Date(UNIX_timestamp * 1000);
  var year = a.getFullYear();
  var month = ("0" + a.getMonth()).slice(-2);
  var date = ("0" + a.getDate()).slice(-2);
  var hour = ("0" + a.getHours()).slice(-2);
  var min = ("0" + a.getMinutes()).slice(-2);
  var sec = ("0" + a.getSeconds()).slice(-2);
  var parsingTime = date + '-' + month + '-' + year + ' ' + hour + ':' + min + ':' + sec;
  return parsingTime;
};

var tmpCnt = 0;
setInterval(function () {

  tmpCnt += 1;
  var blockTimestamp = web3.eth.getBlock('latest').timestamp;
  var peerCount = web3.net.peerCount;
  var latestBlockHash = web3.eth.getBlock('latest').hash;
  var blockNumber = web3.eth.blockNumber;
  var transactionLength = web3.eth.getBlock('latest').transactions.length;
  var blockSize = (web3.eth.getBlock('latest').size) / 1000;
  var gasUsed = (web3.eth.getBlock('latest').gasUsed) / 1000000;
  gasUsed = gasUsed.toFixed(2);

  document.getElementById('console').innerHTML = document.getElementById('console1').innerHTML;
  document.getElementById('console1').innerHTML = document.getElementById('console2').innerHTML;
  document.getElementById('console2').innerHTML = document.getElementById('console3').innerHTML;
  document.getElementById('console3').innerHTML = document.getElementById('console4').innerHTML;

  if (tmpCnt < 4) {
    document.getElementById('console4').innerHTML = 'Block Info: ' + timeConverter(blockTimestamp) + ' Imported ' + '#' + blockNumber + ' ' +
      latestBlockHash.slice(0, 4) + '...' + latestBlockHash.slice(-4) + ' ' + '( ' + transactionLength +
      ' txs, ' + blockSize + ' kiB ' + gasUsed + ' Mgas' + ' )';
  } else {
    document.getElementById('console4').innerHTML = 'Peer Info: ' + peerCount + '/25 peers';
    tmpCnt = 0;
  }

}, 3000);

// windows onload functions
function start() {
  getAllAddedOlis();
  watchpbid();
  watchcbid();
  oliClock.startClock();
  watchMCP();
}
window.onload = start;
