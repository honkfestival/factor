! Copyright (C) 2008 Doug Coleman.
! Copyright (C) 2009 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: colors fonts cairo.ffi alien alien.c-types kernel accessors
sequences namespaces fry continuations destructors math images
images.memory ;
IN: cairo

ERROR: cairo-error message ;

: (check-cairo) ( cairo_status_t -- )
    dup CAIRO_STATUS_SUCCESS =
    [ drop ] [ cairo_status_to_string cairo-error ] if ;

: check-cairo ( cairo -- ) cairo_status (check-cairo) ;

: with-cairo ( cairo quot -- )
    '[
        _ &cairo_destroy
        _ [ check-cairo ] bi
    ] with-destructors ; inline

: check-surface ( surface -- ) cairo_surface_status (check-cairo) ;

: with-surface ( cairo_surface quot -- )
    '[
        _ &cairo_surface_destroy
        _ [ check-surface ] bi
    ] with-destructors ; inline

: with-cairo-from-surface ( cairo_surface quot -- )
    '[ cairo_create _ with-cairo ] with-surface ; inline

: width>stride ( width -- stride ) "uint" heap-size * ; inline

: <image-surface> ( data dim -- surface )
    [ CAIRO_FORMAT_ARGB32 ] dip first2 over width>stride
    cairo_image_surface_create_for_data
    dup check-surface ;

: <cairo> ( surface -- cairo ) cairo_create dup check-cairo ; inline

: make-bitmap-image ( dim quot -- image )
    '[
        <image-surface> &cairo_surface_destroy
        cairo_create &cairo_destroy
        @
    ] make-memory-bitmap
    BGRA >>component-order ; inline

: dummy-cairo ( -- cr )
    #! Sometimes we want a dummy context; eg with Pango, we want
    #! to measure text dimensions to create a new image context with,
    #! but we need an existing context to measure text dimensions
    #! with so we use the dummy.
    \ dummy-cairo [
        CAIRO_FORMAT_ARGB32 0 0 cairo_image_surface_create
        cairo_create
    ] initialize-alien ;

: set-source-color ( cr color -- )
    >rgba-components cairo_set_source_rgba ;