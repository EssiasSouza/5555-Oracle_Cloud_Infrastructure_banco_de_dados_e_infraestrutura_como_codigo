<?php

function portal_cloud_assets() {

  wp_enqueue_style(
    'portal-cloud-style',
    get_stylesheet_uri(),
    [],
    filemtime(get_stylesheet_directory() . '/style.css')
  );

  wp_enqueue_script(
    'portal-cloud-preloader',
    get_template_directory_uri() . '/assets/js/preloader.js',
    [],
    false,
    true
  );
}

add_action('wp_enqueue_scripts', 'portal_cloud_assets');

