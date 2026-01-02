<?php get_header(); ?>

<main style="padding: 20px; max-width: 800px; margin: auto;">

<?php while (have_posts()) : the_post(); ?>

  <h1 style="color:#2c3e50;"><?php the_title(); ?></h1>

  <div style="font-size: 16px; line-height: 1.6; text-align: justify;">
    <?php the_content(); ?>
  </div>

<?php endwhile; ?>

</main>

<?php get_footer(); ?>

