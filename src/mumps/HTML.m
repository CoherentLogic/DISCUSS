HTML
 QUIT
 ;
 ;
DOCUMENT()
 ;
 ;
TAG(TAG,ATTRS,CONTENT)
 N OUTPUT,ATTR S ATTR=""
 S OUTPUT="<"_TAG
 F  S ATTR=$O(ATTRS(ATTR)) Q:ATTR=""  D
 . S OUTPUT=OUTPUT_" "_ATTR_"="""_ATTRS(ATTR)_""""
 S:$L(CONTENT) OUTPUT=OUTPUT_">"_CONTENT_"</"_TAG_">"_$C(13)_$C(10)
 S:'$L(CONTENT) OUTPUT=OUTPUT_"/>"
 QUIT OUTPUT