// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// require jquery
// require jquery_ujs
// require turbolinks
// require bootstrap-sprockets


function preloadImages(images, callback) {
		var count = images.length;
		if(count === 0) {
				callback();
		}
		var loaded = 0;
		$(images).each(function() {
				$('<img>').attr('src', this).load(function() {
						loaded++;
						if (loaded === count) {
								callback();
						}
				});
		});
};

function clear_alerts(){
	if($(".alert:not(.no-remove)").length > 0){
		window.setTimeout(function() {
				$(".alert:not(.no-remove)").fadeTo(500, 0).slideUp(500, function(){
						$(this).remove();
				});
		}, 5000);
	}
}

$(function() {
	var $container = $('#memewall');

	if( $container.length > 0 && $maymays.length > 0 ){
		var $container = $('#memewall').masonry({
			itemSelector: '.wall-item',
			columnWidth: '.wall-item'
		});
		$msnry = $container.data('masonry');

		$.each($maymays, function(index, value){
			preloadImages(["/gen/medium___"+value.filename+""], function(){
				var item = $('<div class="wall-item">'+
					'<a href="/info/'+value.id32+'">'+
					'<img src="/gen/medium___'+value.filename+'" alt="'+value.alt+'" class="img-responsive">' +
					'</a>' +
				'</div>')
				$container.append(item)
				$msnry.appended(item)
				$msnry.layout()

			})
		})



		/*
		$container.infinitescroll({
			navSelector  : '#page-nav',    // selector for the paged navigation
			nextSelector : '#page-nav a',  // selector for the NEXT link (to page 2)
			itemSelector : '.wall-item',     // selector for all items you'll retrieve
			loading: {
					finishedMsg: 'No more pages to load.',
					img: 'http://i.imgur.com/6RMhx.gif'
				}
			},
			// trigger Masonry as a callback
			function( newElements ) {
				var $newElems = $( newElements );
				$container.masonry( 'appended', $newElems );
			}
		);*/

	}
})

function show_on_screen_images(){

}

function setGetParameter(paramName, paramValue)
{
		var url = window.location.href;
		if (url.indexOf(paramName + "=") >= 0)
		{
				var prefix = url.substring(0, url.indexOf(paramName));
				var suffix = url.substring(url.indexOf(paramName));
				suffix = suffix.substring(suffix.indexOf("=") + 1);
				suffix = (suffix.indexOf("&") >= 0) ? suffix.substring(suffix.indexOf("&")) : "";
				url = prefix + paramName + "=" + paramValue + suffix;
		}
		else
		{
		if (url.indexOf("?") < 0)
				url += "?" + paramName + "=" + paramValue;
		else
				url += "&" + paramName + "=" + paramValue;
		}
		window.location.href = url;
}

$(document).ready(function(){

	/*$(window).scroll(function() {
	   	if($(window).scrollTop() + $(window).height() == $(document).height()) {
		   	if( $(".footer-wrapper .alert").length <= 0 ){
	       		$(".footer-wrapper").prepend('<div class="alert alert-info" style="margin-top:-16px">Loading more images...</div>')

	       		var json_uri_ = window.location.href.toString().split("?", 2)
	       		var json_uri__ = json_uri_[0].split("/")
	       		var page_ = json_uri__.pop
	       		if(page_ == '' || page_ == ' ')
		       		page_ = json_uri__.pop
	       		json_uri = json_uri__.join('/')+"/"+(parseInt(page_)+1)+".json"
	       		if(json_uri_[1] && json_uri_[1] != '')
	       			json_uri += "?"+json_uri_[1] 
	       		$.getJSON(json_uri, function(data){
	       			console.log(data);
	       		})
		   	}
	   	}
	});*/

	clear_alerts()

	$("#gen_clear").on('click', function(){
		$("#gen_bottom").val("")
		$("#gen_top").val("")
	})

	if($("#newname").length > 0){
		function save_newname(){
			var name = $("#newname").val()
			window.location = "/change_name_action/"+name;
		}

		var check_new_name;

		$("#newname").on('keyup', function(e){
			$(this).val( $(this).val().replace(/[^A-Za-z0-9_]/g, '') )
			$("#save_newname").attr('disabled', 'disabled')

			var code = (e.keyCode ? e.keyCode : e.which);
			if (code==13) {
				save_newname()
			} else {
				window.clearTimeout(check_new_name)
				var name = $(this).val()
				check_new_name = window.setTimeout(function(){
					if(name.length > 2){
						$.getJSON("/user/"+name+".json", function(data){
							$("#newname_icon").removeClass('fa-bolt').removeClass('fa-check-square-o').addClass('fa-remove')
						}).error(function() {
							$("#newname_icon").removeClass('fa-bolt').removeClass('fa-remove').addClass('fa-check-square-o')
							$("#save_newname").removeAttr('disabled')
						})
					}
				}, 400)
			}
		})


		$("#save_newname").on('click', function(){
			save_newname()
		})
	}

	$("#sort_by").on('change', function(){
		setGetParameter("sort", $(this).val())
	})
	$("#meme_list_search").on('click', function(){
		setGetParameter("q", $("#meme_list_search_text").val())
	})
	$("#meme_list_search_text").keypress(function(e){
		if(e.which == 13) {
			setGetParameter("q", $("#meme_list_search_text").val())
		}
	})

	$("#gen_maymay").on('click', function(){
		var meme 	= $("#gen_meme").val()
		var top 	= $("#gen_top").val().replace(/[?]/g, "%3F")
		var bottom 	= $("#gen_bottom").val().replace(/[?]/g, "%3F")


		$("#gen_result").slideUp('fast')

		if((top == "" && bottom == "") || meme == ""){
			$("#gen_maymay").parent().addClass('has-error')
		} else {
			if(top == ""){ top = " "; }

			$("#gen_maymay").parent().removeClass('has-error')
			var path = '/'+meme+"/"+top.toLowerCase()
			if(bottom != ""){
				path += "/"+bottom.toLowerCase()
			}

			$("#gen_link_full").val( global_domain + path.replace(/ /g, '_') + ".jpg" )
			$("#image_preview_container .loading").fadeIn('fast')
			$.getJSON( path+".json", function( data ) {
				console.log("Your generated image:")
				console.log(data)
				if(data.status == "500"){
					$("#alert-container").append('<div class="alert alert-danger" style="display:none;" role="alert">'+
						'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'+
						'<span aria-hidden="true">&times;</span></button>Creating image failed... damn</div>')
						$("#alert-container .alert").slideDown('normal')
						clear_alerts()
				} else {
					preloadImages([data.url], function() {
						$("#gen_link_short").val(data.short_url)
						$("#gen_link_view").val(data.view_url)
						$("#gen_result").slideDown('normal')
						$("#prev_maymay").attr('src', data.url)
						$("#prev_maymay").parent().attr('href', data.view_url)

						var __text = data.top_text
						if(__text == " " || __text == ""){ __text = data.bottom_text }
						$("#gen_share_twitter").attr('href', 'https://twitter.com/intent/tweet?text='+__text+'&url='+data.short_url+'&via=MayMay_in')
						$("#gen_share_reddit").attr('href', 'https://www.reddit.com/submit?url='+data.short_url+'&title='+__text)
						$("#gen_share_google").attr('href', 'https://plus.google.com/share?url='+data.short_url)
						$("#gen_share_facebook").attr('href', 'https://www.facebook.com/sharer/sharer.php?u='+data.short_url)

						$("#gen_info_link").attr('href', data.view_url)
						$("#image_preview_container .loading").fadeOut('fast')
						
						$("#alert-container .alert").fadeOut(function(){
							$(this).remove()
						})

						if(data.status == "new"){

							$("#alert-container").append('<div class="alert alert-info" style="display:none;" role="alert">'+
								'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'+
								'<span aria-hidden="true">&times;</span></button>Your new MayMay has been created</div>')
						} else {
							if(current_user == data.creator){
								$("#alert-container").append('<div class="alert alert-warning" style="display:none;" role="alert">'+
									'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'+
									'<span aria-hidden="true">&times;</span></button>This MayMay already was created by '+
									'yourself!</div>')
							} else {
								$("#alert-container").append('<div class="alert alert-warning" style="display:none;" role="alert">'+
									'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'+
									'<span aria-hidden="true">&times;</span></button>This MayMay already was created by '+
									'<a href="/user/'+data.creator+'" class="alert-link">'+data.creator+'</a></div>')
							}
						}
						$("#alert-container .alert").slideDown('normal')
						clear_alerts()
					});
				}
			}).error(function(){
				$("#alert-container").append('<div class="alert alert-danger" style="display:none;" role="alert">'+
					'<button type="button" class="close" data-dismiss="alert" aria-label="Close">'+
					'<span aria-hidden="true">&times;</span></button>Creating image failed... damn</div>')
					$("#alert-container .alert").slideDown('normal')
					clear_alerts()
			});
		}
	});

	$("a[href=#full_url]:not(.active)").on('click', function(){
		$("#gen_link_short").slideUp()
		$("#gen_link_view").slideUp()
		$("#gen_link_full").slideDown()
		$("a.active").removeClass('active')
		$(this).addClass('active')
	})

	$("a[href=#short_url]:not(.active)").on('click', function(){
		$("#gen_link_full").slideUp()
		$("#gen_link_view").slideUp()
		$("#gen_link_short").slideDown()
		$("a.active").removeClass('active')
		$(this).addClass('active')
	})

	$("a[href=#view_url]:not(.active)").on('click', function(){
		$("#gen_link_full").slideUp()
		$("#gen_link_short").slideUp()
		$("#gen_link_view").slideDown()
		$("a.active").removeClass('active')
		$(this).addClass('active')
	})

	// :)
	var kkeys = [], konami = "38,38,40,40,37,39,37,39,66,65";
	$(document).keydown(function(e) {
		kkeys.push( e.keyCode );
		if ( kkeys.toString().indexOf( konami ) >= 0 ){
			$(document).unbind('keydown',arguments.callee);
			var KICKASSVERSION='2.0';var s = document.createElement('script');s.type='text/javascript';document.body.appendChild(s);s.src='//hi.kickassapp.com/kickass.js';void(0);
		}
	});

	// Ad blocker is the fucking pest, why would anything block fucking links just because they mention social?
	// What are we? 2050?


});


$(window).load(function() {
	// Making the layout less ugly for adblocked users :3
	window.setTimeout(function(){
		if ($('ins[data-adsbygoogle-status="done"]').length < 1){
			console.log("~~~")
			console.log("I see you are using Adblock. Well i usually do as well.")
			console.log("This project does use quite some server resources, which arent that cheap.")
			console.log("At at this point adsense is sorrily our best consideration.")
			console.log("(we do have other plans for the future if this site works out!)")
			console.log("")
			console.log("You may could consider turning Adblock off, but lets keep it realistic.")
			console.log("Please consider sharing us to your friends instead, thank you <3")
			console.log("")
			console.log("~ roman")
			$("ins, .no-ad").hide()
		}
	}, 100);
})
