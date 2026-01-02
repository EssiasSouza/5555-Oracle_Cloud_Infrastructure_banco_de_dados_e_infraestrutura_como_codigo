<footer>
  <p>
    <?php
      if (get_bloginfo('description')) {
        bloginfo('description');
      } else {
        echo 'Curso Alura - Oracle Cloud Infrastructure: banco de dados e infraestrutura como código';
      }
    ?>
  </p>
</footer>

</div> <!-- /.site -->

<?php wp_footer(); ?>
</body>
</html>

