<?php get_header(); ?>

<main>

<?php if (have_posts()) : ?>

  <div style="display:grid; grid-template-columns:1fr 1fr; gap:20px; padding:20px;">

  <?php while (have_posts()) : the_post(); ?>

    <div style="background:#fff; padding:20px; border:1px solid #ddd; border-radius:5px;">
      <h2 style="color:#2c3e50;">
        <a href="<?php the_permalink(); ?>">
          <?php the_title(); ?>
        </a>
      </h2>

      <p style="font-size:16px; line-height:1.6; text-align:justify;">
        <?php the_excerpt(); ?>
      </p>
    </div>

  <?php endwhile; ?>

  </div>

<?php else : ?>
  <p>Nenhuma publicação encontrada.</p>
<?php endif; ?>

</main>

<?php get_footer(); ?>

