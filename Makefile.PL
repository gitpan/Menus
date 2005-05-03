
      use ExtUtils::MakeMaker;
      use File::Copy;
#    unless (eval "use Module::Build::Compat 0.02; 1" ) {
if (1) {
      print "Module::Build is recommended (but not necessary).\n";
      
      require ExtUtils::MakeMaker;
      my $yn = ExtUtils::MakeMaker::prompt
	('  Install Module::Build now from CPAN?', 'y|n');
      
      unless ($yn =~ /^y/i) {
        move "Build.PL", "Build.TMP";
        move "MANIFEST", "MANIFEST.TMP";
        open (RH,"<MANIFEST.TMP");
        open (WH,">MANIFEST");
        while (<RH>) {
           print WH $_ if !/Build.PL/;
        };
        WriteMakefile(
           NAME          => 'Menus',
           VERSION_FROM  => 'lib/Menus.pm',
           dist          => { COMPRESS => "gzip", SUFFIX => "gz" },
           AUTHOR => "Brian M. Kelly <Brian.Kelly\@fullautosoftware.com>",
        );
        move "Build.TMP", "Build.PL";
        move "MANIFEST.TMP", "MANIFEST";
        move "Makefile", "Makefile.TMP";
        open (RH,"<Makefile.TMP");
        open (WH,">Makefile");
        while (<RH>) {
           if (/^all\s*::/) {
              chomp($_);
              print WH "$_ manifypods\n";
           } else {
              print WH $_;
           }
        } close WH;close FH;unlink 'Makefile.TMP';
        
	#die " *** Cannot install without Module::Build.  Exiting ...\n";
        exit;
      } else {
      
         require Cwd;
         require File::Spec;
         require CPAN;
      
         # Save this 'cause CPAN will chdir all over the place.
         my $cwd = Cwd::cwd();
         my $makefile = File::Spec->rel2abs($0);
      
         CPAN::Shell->install('Module::Build::Compat')
            or die " *** Cannot install without Module::Build.  Exiting ...\n";
      
         chdir $cwd or die "Cannot chdir() back to $cwd: $!";
      }
    }
    eval "use Module::Build::Compat 0.02; 1" or die $@;
    use lib '_build/lib';
    Module::Build::Compat->run_build_pl(args => \@ARGV);
    require Module::Build;
    Module::Build::Compat->write_makefile(build_class => 'Module::Build');
