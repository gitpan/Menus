use strict;

# On some platforms (*ahem*, MacPerl 5.6.1) "use lib qw(lib);" doesn't
# find the local "lib" directory, so we use File::Spec to do it properly.
use File::Spec;
use lib File::Spec->catdir('lib');

# We use Module::Build to test & install itself.
use Module::Build;

Module::Build->new(
   module_name => 'Menus',
   license     => 'gpl',
   requires => { perl => '5.002' },
   auto_features => {
               YAML_support =>
               {
                  description => "Can write fully-functional META.yml files",
                  requires => { YAML => ' >= 0.35, < 0.49 ' },
               },
            },
   dist_author => "Brian Kelly <Brian.Kelly\@fullautosoftware.net>",
   sign => 1,
   create_makefile_pl => 'passthrough',
   create_readme => 1,
   create_packlist => 1,
)->create_build_script;

