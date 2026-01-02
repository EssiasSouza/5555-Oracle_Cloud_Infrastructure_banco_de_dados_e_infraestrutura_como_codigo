<?php
/**
 * Plugin Name: Enable Application Passwords (DEV)
 * Description: Habilita Application Passwords em ambiente HTTP para desenvolvimento.
 */

add_filter( 'wp_is_application_passwords_available', '__return_true' );
