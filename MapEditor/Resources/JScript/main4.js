var lastSprite = null;

$(document).ready(function(){

	$("#elements img").draggable( { 
    	helper:		'clone',
    	appendTo:	'body',
    	containment:'body',
    	start: function(event, ui) {
			if( ui.helper[0].src.match(/[ABCDS]\d+/) ){
				ui.helper[0].style.border = '1px dashed red';
				ui.helper[0].style.zIndex = '20';
			}
		}
	} );

	$("#elements img").each(function(){
		var id = this.src.match(/\/([^\/]+).png/);
		this.id = 'Tile'+id[1];
	});
	
	makeNewMapWithSize( 15, 10 );
	
});


function changeHelpersState() {
	if( $('#elements > #helpers').is(":visible") ){
		$('#elements > #helpers').fadeOut( 'slow' );
		
		$('#map #TileA256').fadeOut();
		$('#map #TileA1024').fadeOut();
		$('#map #TileA128').fadeOut();
		
		$('#map #TileB512').fadeOut();
		$('#map #TileB128').fadeOut();
		$('#map #TileB256').fadeOut();
		
		$('#map #TileD128').fadeOut();
		$('#map #TileD1024').fadeOut();
		$('#map #TileD512').fadeOut();

		$('#map #TileC256').fadeOut();
		$('#map #TileC1024').fadeOut();
		$('#map #TileC512').fadeOut();
		
	}else{
		$('#elements > #helpers').fadeIn( 'slow' );
		
		$('#map #TileA256').fadeIn();
		$('#map #TileA1024').fadeIn();
		$('#map #TileA128').fadeIn();
		
		$('#map #TileB512').fadeIn();
		$('#map #TileB128').fadeIn();
		$('#map #TileB256').fadeIn();
		
		$('#map #TileD128').fadeIn();
		$('#map #TileD1024').fadeIn();
		$('#map #TileD512').fadeIn();

		$('#map #TileC256').fadeIn();
		$('#map #TileC1024').fadeIn();
		$('#map #TileC512').fadeIn();
	}
}


function moveHelpers( to ){
	
	if( to > 0 ){

		$('#map #TileA256').css('z-index', '15');
		$('#map #TileA1024').css('z-index', '15');
		$('#map #TileA128').css('z-index', '15');
		
		$('#map #TileB512').css('z-index', '15');
		$('#map #TileB128').css('z-index', '15');
		$('#map #TileB256').css('z-index', '15');
		
		$('#map #TileD128').css('z-index', '15');
		$('#map #TileD1024').css('z-index', '15');
		$('#map #TileD512').css('z-index', '15');

		$('#map #TileC256').css('z-index', '15');
		$('#map #TileC1024').css('z-index', '15');
		$('#map #TileC512').css('z-index', '15');
		
	}else{
		
		$('#map #TileA256').css('z-index', '5');
		$('#map #TileA1024').css('z-index', '5');
		$('#map #TileA128').css('z-index', '5');
		
		$('#map #TileB512').css('z-index', '5');
		$('#map #TileB128').css('z-index', '5');
		$('#map #TileB256').css('z-index', '5');
		
		$('#map #TileD128').css('z-index', '5');
		$('#map #TileD1024').css('z-index', '5');
		$('#map #TileD512').css('z-index', '5');

		$('#map #TileC256').css('z-index', '5');
		$('#map #TileC1024').css('z-index', '5');
		$('#map #TileC512').css('z-index', '5');
		
	}
	
}


function newMap(){
	makeNewMapWithSize( prompt('grid width?'), prompt('grid height?') );
}


function makeNewMapWithSize( width, height ){
	if( width < 5 || width > 100 ){
		alert('common, enter normal size...');
		return;
	}
	if( height < 5 || height > 100 ){
		alert('common, enter normal size...');
		return;
	}
	
	var body = '';
	for( var h=0; h<height; h++ ){
		body += '<tr>';
		for( var w=0; w<width; w++ ){
			body += '<td valign="top"></td>';	
		}
		body += '</tr>';
	}
	
	$('#mapHolder').html('');
	$('#mapHolder').append($('<table align="center" id="map">' +body +'</table>'));
	

	$("#map td").droppable({
		greedy: true,
		drop: 	function( event, ui ) {
			dropSprite( $(this), ui.draggable );
		}
	});
	
	
	$("#map td").bind('mousemove', function( e ){
		if( !lastSprite || !e.shiftKey ) return;
		dropSprite( $(e.target), lastSprite );	
	});
} 


function dropSprite( ref, obj ){
	if( !obj.length ){
		console.error( 'dropSprite: Tile not given' );
		return;
	}

	if( ref[0].tagName != 'TD' ){
		ref = $(ref).parent('td');
	}
	
	if( obj[0].src.match(/Clear/) ){
		ref.html('');
	}else if( obj[0].src.match(/S\d+/) ){
		ref.html('');
		ref.append( obj.clone() );
	}else{
		ref.append( obj.clone() );
	}

	lastSprite = obj;
	
	fixArrowsOnCell( ref );
}


var WalkPathWalk  = 0;
var WalkPathToTop   = 1 << 1;
var WalkPathToRight = 1 << 2;
var WalkPathToBottom= 1 << 3;
var WalkPathToLeft  = 1 << 4;
var WalkPathEntrance= 1 << 5;
var WalkPathExit	= 1 << 6;

var ZeroPathToTop   = 1 << 9;
var ZeroPathToRight = 1 << 10;
var ZeroPathToBottom= 1 << 7;
var ZeroPathToLeft  = 1 << 8;

function fixArrowsOnCell( ref ){
	$(ref).find('img').each(function(){
		var path = this.src.match(/([ABCD])(\d+)/);
		if( !path ) return;
		
		var toSide = parseInt(path[2]);
		
		if( wp = cellGotWalkPath( ref, sideToPath( path[1] ) ) ){
			//yra? reikia prideti priesinga sitam tailui :)
			//console.log(path[0], wp, mirrorOfPath(path[0]) );
			if( mirrorPath = mirrorOfPath(path[0]) ){
				if( !cellGotArrow( ref, mirrorPath ) ){
					var img = new Image();
						img.src = 'Resources/Images/a/' +mirrorPath +'.png'
						img.id  = 'Tile' +mirrorPath;
						img.className='ui-draggable';
					dropSprite( ref, $(img) );
				}
			}
		}

		//console.log(path);
	});
}


function cellGotArrow( ref, arrow ){
	var imgs = $(ref).find('img');
	
	for( var i=0; i<imgs.length; i++ ){
		var path = imgs[i].src.match(/([ABCD])(\d+)/);
		if( path[0] == arrow ){
			return true;
		}
	}
	
	return false;
}


function cellGotWalkPath( ref, wp ){
	var imgs = $(ref).find('img');
	
	for( var i=0; i<imgs.length; i++ ){
		var path = imgs[i].src.match(/([ABCD])(\d+)/);
		if( parseInt(path[2]) & wp ){
			return path[0];
		}
	}
	
	return null;
}


function opositeSideOf( side ){
	if( side == 'A' ) return 'C';
	if( side == 'B' ) return 'D';
	if( side == 'C' ) return 'A';
	if( side == 'D' ) return 'B';
}


function mirrorOfPath( path ){
	if( path == 'B16' ) return 'D4';
	if( path == 'D4' ) 	return 'B16';
	if( path == 'C2' ) 	return 'A8';
	if( path == 'A8' ) 	return 'C2';
	if( path == 'C16' ) return 'D8';
	if( path == 'D8' ) 	return 'C16';
	if( path == 'C4' ) 	return 'B8';
	if( path == 'B8' ) 	return 'C4';
	if( path == 'A16' ) return 'D2';
	if( path == 'D2' ) 	return 'A16';
	if( path == 'B2' ) 	return 'A4';
	if( path == 'A4' ) 	return 'B2';

	//console.error('Unknown path ' +path);
}


function sideToPath( side ){
	if( side == 'A' ) return WalkPathToTop;
	if( side == 'B' ) return WalkPathToRight;
	if( side == 'C' ) return WalkPathToBottom;
	if( side == 'D' ) return WalkPathToLeft;
}


function saveMap(){
	var win = window.open();

	var tr = $("#map tr").length -1;
	var td = 0;
	
	win.document.write('&lt;?xml version="1.0" encoding="UTF-8"?&gt;&lt;!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"&gt;&lt;plist version="1.0"&gt;'+"\n&lt;dict&gt;\n");	
	$("#map tr").each(function(){
		td=0;
		
		//tr
		win.document.write("&lt;key&gt;tr" +tr +"&lt;/key&gt;\n&lt;dict&gt;\n");
		$(this).find('td').each(function(){
			var A=WalkPathWalk;
			var B=WalkPathWalk;
			var C=WalkPathWalk;
			var D=WalkPathWalk;
			
			//td
			$(this).find('img').each(function(){
				if( path = this.src.match(/S\d+/) ){
					 A=B=C=D=path[0];
				}else if( path = this.src.match(/\/(\w)(\d+)/) ){
					eval(path[1]+' = '+path[1]+' | parseInt(path[2]);');
				}else if( this.src.match(/Entrance/) ){
					A=B=C=D=WalkPathEntrance;
				}else if( this.src.match(/Exit/) ){
					A=B=C=D=WalkPathExit;
				}
			});

			win.document.write("&lt;key&gt;td" +td +"&lt;/key&gt;\n");
			win.document.write("&lt;string&gt;"+[A,B,C,D].join('|') +"&lt;/string&gt;\n");
			
			td++;
		});
		win.document.write("&lt;/dict&gt;\n");
		
		tr--;
	});
	win.document.write("&lt;/dict&gt;\n&lt;/plist&gt;");
}


function loadMap(){
	var map = prompt('map:');
	
	$('#mapHolder').html('');
	
	var sideNames = ['A', 'B', 'C', 'D'];
	var parser = new DOMParser();
	var xml = parser.parseFromString(map, "application/xml");

	var trs = xml.getElementsByTagName("dict")[0].getElementsByTagName("dict");
	for (var y = 0; y < trs.length; y++) {
		var tds = trs[y].getElementsByTagName('string');
		
		if( !$('#map').length ){
			makeNewMapWithSize( tds.length, trs.length );
		}
		
		for ( var x = 0; x < tds.length; x++ ) {
			var sides = tds[x].firstChild.data.split('|');
			
			for( s=0; s<4; s++ ){
				if( sides[s].match(/S\d+/) ){
					dropSprite( $($($('#map').find('tr')[y]).find('td')[x]), $('#Tile'+sides[s]) );					
					break;
				}else if( sides[s] == WalkPathEntrance ){
					dropSprite( $($($('#map').find('tr')[y]).find('td')[x]), $('#TileEntrance') );
					break;
				}else if( sides[s] == WalkPathExit ){
					dropSprite( $($($('#map').find('tr')[y]).find('td')[x]), $('#TileExit') );
					break;
				}else if( sides[s] != '0' ){
					sides[s] = parseInt(sides[s]);

					if( sides[s] & WalkPathToTop ){
						dropSprite( $($($('#map').find('tr')[y]).find('td')[x]), $('#Tile'+sideNames[s]+WalkPathToTop) );
					}
					if( sides[s] & WalkPathToRight ){
						dropSprite( $($($('#map').find('tr')[y]).find('td')[x]), $('#Tile'+sideNames[s]+WalkPathToRight) );
					}						
					if( sides[s] & WalkPathToBottom ){
						dropSprite( $($($('#map').find('tr')[y]).find('td')[x]), $('#Tile'+sideNames[s]+WalkPathToBottom) );
					}
					if( sides[s] & WalkPathToLeft ){
						dropSprite( $($($('#map').find('tr')[y]).find('td')[x]), $('#Tile'+sideNames[s]+WalkPathToLeft) );
					}
					
					if( sides[s] & ZeroPathToTop ){
						dropSprite( $($($('#map').find('tr')[y]).find('td')[x]), $('#Tile'+sideNames[s]+ZeroPathToTop) );
					}
					if( sides[s] & ZeroPathToRight ){
						dropSprite( $($($('#map').find('tr')[y]).find('td')[x]), $('#Tile'+sideNames[s]+ZeroPathToRight) );
					}						
					if( sides[s] & ZeroPathToBottom ){
						dropSprite( $($($('#map').find('tr')[y]).find('td')[x]), $('#Tile'+sideNames[s]+ZeroPathToBottom) );
					}
					if( sides[s] & ZeroPathToLeft ){
						dropSprite( $($($('#map').find('tr')[y]).find('td')[x]), $('#Tile'+sideNames[s]+ZeroPathToLeft) );
					}
					
				}
			}
		}
	}
}