
		var map = L.map('map').setView([52.4756,-1.89342], 6);
		var plotlayers=[];
		var mylayer="";

		L.tileLayer('http://{s}.tile.cloudmade.com/BC9A493B41014CAABB98F0471D759707/997/256/{z}/{x}/{y}.png', {
			maxZoom: 18,
			attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>'
		}).addTo(map);


		function onMapChng(e) {
			getViewPort();
		}

	function onMapMove(e) {
			getViewPort();
		}
						
        function getViewPort() {{
        var bounds=map.getBounds();
		var minll=bounds.getSouthWest();
		var maxll=bounds.getNorthEast();
        XsltForms_xmlevents.dispatch(document.getElementById("test"),
                    "callbackevent", null, null, null, null,
                    {
                        latitude:  minll.lat + ',' + minll.lng,
                        longitude: maxll.lat + ',' + maxll.lng
                    });
            }
        }    
		
       
/*       
       function rePlot() {
			removeMarkers();
			var plotlist = document.getElementById("reslist").getElementsByClassName("xforms-value");
			for (i=0;i<plotlist.length;i++) {
				var fields = plotlist[i].innerHTML.split(',');
				var name = fields[0];			
				var plotll = new L.LatLng(fields[0],fields[1], true);
				var plotmark = new L.Marker(plotll);
				plotmark.data=plotlist[i];
				map.addLayer(plotmark);
				plotlayers.push(plotmark);
			}
			//map.panTo(plotlayers[0].getLatLng());
		}
		


function removeMarkers() {
	for (i=0;i<plotlayers.length;i++) {
		map.removeLayer(plotlayers[i]);
	}
	plotlayers=[];
}
*/


function rePlot() {
			var groupmarker=[];
			var plotlist = document.getElementById("reslist").getElementsByClassName("xforms-value");
			map.removeLayer(mylayer);
			for (i=0;i<plotlist.length;i++) {
			//alert(plotlist[i].innerHTML);	
				var fields = plotlist[i].innerHTML.split(',');	
				var plotll = new L.LatLng(fields[0],fields[1], true);
				var plotmark = new L.Marker(plotll);
				groupmarker[i]=plotmark; 
			}
			mylayer = L.featureGroup(groupmarker); 
			map.addLayer(mylayer);
		}
		


function removeMarkers() {
	map.removeLayer(mylayer);
}


		function centermap() {
		 	map.off('moveend', onMapMove);
			map.fitBounds(mylayer.getBounds());
			map.on('moveend' ,onMapMove);
		}



       			
		map.on('moveend', onMapMove);
		
		
	
