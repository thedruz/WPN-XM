<?php
include __DIR__ . DIRECTORY_SEPARATOR . 'serverpack.core.php';
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
    <head>
        <title>WPN-XM Serverpack for Windows</title>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <link rel="shortcut icon" href="http://clansuite.com/favicon.ico" />
        <link rel="stylesheet" type="text/css" href="http://cdn.clansuite.com/css/topnavigation.css" />
        <style type="text/css">
            <!--
            body
            {
                margin: 0;
                padding: 0;
                font-family:  verdana, tahoma, arial, geneva, helvetica, sans-serif;
                background: #d5d6d7 url("http://cdn.clansuite.com/images/kubrickbgcolor.png");
                font-size: 65%; /* Resets 1em to 10px */
                font-family: 'Lucida Grande', Verdana, Arial, Sans-Serif;
                color: #333;
                text-align: center;
            }

            img
            {
                border: 0px;
            }

            .resourceheader
            {
                margin-left:    10px;
                text-align:     left;
                font-size:      12px;
            }

            .td-with-image
            {
                border-right:   1px dotted #B4B4B4;
                padding-right:  10px;
                width:          55px;
            }

            .footer
            {
                font-family: verdana, tahoma;
                font-size: 9px;
                /*text-align: center;*/
                /*margin: auto;*/
            }

            ul
            {
                list-style-position:    outside;
                list-style-type:        none;
            }

            .cs-message
            {
                background: none repeat scroll 0 0 #CDCDCD;
                border-radius: 8px 8px 8px 8px;
                padding: 5px;
                margin-top: 10px;
            }

            .cs-message-content
            {
                background: none repeat scroll 0 0 #F4F4F4;
                border: 1px solid #A7A7A7;
                border-radius: 6px 6px 6px 6px;
                padding: 10px;
                margin-top: 3px;
                margin-bottom: 2px;
                width: 336px;
                height: 100px;
            }

            .cs-message h3
            {
                margin: 5px;
                font-size: 13px;
            }

            .res-header-icon
            {
                vertical-align: text-top;
            }

            h1, h2 {
                text-shadow: 0 1px #FFFFFF;
            }

            .horizontal-rule-light, heading, hr {
                border-bottom: 1px solid #BBBBBB;
                box-shadow: 0 1px 0 white;
                padding-bottom: 10px;
            }

            .inset-panel, #phpinfo table {
                background: none repeat scroll 0 0 rgba(0, 0, 0, 0.04);
                box-shadow: 0 1px 1px white, 0 0 1px 0 rgba(0, 0, 0, 0.5) inset;
                padding: 10px;
            }

            #search { 
                margin-left: 165px;
                padding-left: 160px;
                margin-top: 0;
                padding-bottom: 0;
                padding-top: 15px;
            }
            #highlight { background:yellow; }
            .highlight { background-color:yellow; color:inherit; text-decoration:inherit }
            
            #phpinfo {}
            #phpinfo pre { margin: 0px; font-family: monospace; }
            #phpinfo a:link {}
            #phpinfo a:hover {}
            #phpinfo table { }
            #phpinfo .center { text-align: center; }
            #phpinfo .center table { margin-left: auto; margin-right: auto; text-align: left; }
            #phpinfo .center th { text-align: center !important; }
            #phpinfo td, th { font-size: 120%; vertical-align: baseline; }
            #phpinfo h1 {}
            #phpinfo h2 { font-size: 175%; }
            #phpinfo .p { text-align: left; }
            #phpinfo .e { background-color: #aaa; color: #000000; font-weight: bold; }
            #phpinfo .h { background-color: #9999cc; font-weight: bold; color: #000000;}
            #phpinfo .v { background-color: #bbb; color: #000000; }
            #phpinfo .vr { background-color: #cccccc; text-align: right; color: #000000; }
            #phpinfo img { border: 0 none; float: right; }
            #phpinfo hr { background-color: #CCCCCC; border: 0 none; color: #000000; height: 1px; width: 600px; }
            -->
        </style>
        <?php #require_once dirname(__DIR__) . '/ads/analyticstracking.php'; ?>
    </head>
    <body>
    <center>
            <!-- Main -->
            <div style="width: 960px;">
                <div>
                    <h1 style="margin-top: 40px; margin-bottom: 35px; font-size: 18px;">
                            <b>WPN-XM<br/>Serverpack for Windows</b><br/><small>Version 0.1b</small>
                    </h1>
                </div>
                
                <div>
                Overview -  Tools - Configuration - Help
                </div>

        <div style="margin-right: 2em;">
            <h2 class="heading">Server Environment</h2>
           
            <div class="cs-message">
                <h3>phpinfo()</h3>
                  <div id="search">
                    <label>Search:</label> 
                    <input id="textToHighlight" type="text" value="xdebug">
                    <button id="highlightButton">Search</button>
                    <button id="resetButton">Reset</button>
                  </div>
                  <br /><br />
                  <div id="phpinfo">
                      <?php echo Wpnxm_Serverpack::fetchPHPInfo(); ?>
                  </div>
            </div>
        </div>
    </div>

    </div><!-- Main Ende -->

    <br style="clear:both;" />

    <hr size="1" style="margin-top: 50px; width: 22%;">

    <!-- Fusszeile START -->
    <div class="footer" style="">
        <p>
            &copy; 2005-<?php echo date("Y"); ?> by Jens-Andr&#x00E9; Koch.
        </p>
    </div><!-- Fusszeile ENDE -->
    
    <script type="text/javascript">
        <!--
        (function(){
          var resetHighlight = function(){
            var elems = document.querySelectorAll('.highlight');
            var n = elems.length;
            while (n--){
              var e = elems[n];
              e.parentNode.replaceChild(e.childNodes[0], e);
              }
            };
          var e = document.querySelector('#highlightButton');
          if (!e) {return;}
          e.onclick = function(){
            resetHighlight();
            var e = document.querySelector('#textToHighlight');
            if (!e) {return;}
            var searchFor = new RegExp(e.value.replace(/\s+/g,'\\s+'), 'gi');
            doHighlight('phpinfo', 'highlight', searchFor);
            document.getElementById('highlight').scrollIntoView(true);
            };
          e = document.querySelector('#resetButton');
          if (!e) {return;}
          e.onclick = resetHighlight;
        })();
        
        // Author: Raymond Hill
        // Version: 2011-01-17
        // Title: HTML text hilighter
        // Permalink: http://www.raymondhill.net/blog/?p=272
        // Purpose: Hilight portions of text inside a specified element, according to a search expression.
        // Key feature: Can safely hilight text across HTML tags.
        // Notes: Minified using YUI Compressor (http://refresh-sf.com/yui/),
        function doHighlight(A,c,z,s){var G=document;if(typeof A==="string"){A=G.getElementById(A)}if(typeof z==="string"){z=new RegExp(z,"ig")}s=s||0;var j=[],u=[],B=0,o=A.childNodes.length,v,w=0,l=[],k,d,h;for(;;){while(B<o){k=A.childNodes[B++];if(k.nodeType===3){j.push({i:w,n:k});v=k.nodeValue;u.push(v);w+=v.length}else{if(k.nodeType===1){if(k.tagName.search(/^(script|style)$/i)>=0){continue}if(k.tagName.search(/^(a|b|basefont|bdo|big|em|font|i|s|small|span|strike|strong|su[bp]|tt|u)$/i)<0){u.push(" ");w++}d=k.childNodes.length;if(d){l.push({n:A,l:o,i:B});A=k;o=d;B=0}}}}if(!l.length){break}h=l.pop();A=h.n;o=h.l;B=h.i}if(!j.length){return}u=u.join("");j.push({i:u.length});var p,r,E,y,D,g,F,f,b,m,e,a,t,q,C,n,x;for(;;){r=z.exec(u);if(!r||r.length<=s||!r[s].length){break}E=r.index;for(p=1;p<s;p++){E+=r[p].length}y=E+r[s].length;g=0;F=j.length;while(g<F){D=g+F>>1;if(E<j[D].i){F=D}else{if(E>=j[D+1].i){g=D+1}else{g=F=D}}}f=g;while(f<j.length){b=j[f];A=b.n;v=A.nodeValue;m=A.parentNode;e=A.nextSibling;t=E-b.i;q=Math.min(y,j[f+1].i)-b.i;C=null;if(t>0){C=v.substring(0,t)}n=v.substring(t,q);x=null;if(q<v.length){x=v.substr(q)}if(C){A.nodeValue=C}else{m.removeChild(A)}a=G.createElement("span");a.appendChild(G.createTextNode(n));a.className=c;a.id=c;m.insertBefore(a,e);if(x){a=G.createTextNode(x);m.insertBefore(a,e);j[f]={n:a,i:y}}f++;if(y<=j[f].i){break}}}}
        // -->
        </script>

    </body>
</html>