<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="<?php bloginfo('charset'); ?>">
  <title><?php bloginfo('name'); ?></title>
  <?php wp_head(); ?>
</head>
<body>

<!-- Preloader -->
<div id="preloader" aria-hidden="true">
  <div class="loader">Carregando...</div>
</div>

<header>
  <div class="tech-stack"></div>
  <h1><?php bloginfo('name'); ?></h1>
</header>

<nav>
  <a href="<?php echo home_url(); ?>">Home</a>
  <a href="<?php echo home_url(); ?>">Sobre</a>
  <a href="<?php echo home_url(); ?>">Contato</a>
</nav>

