# Run makeglossaries automatically so that the list of acronyms (.acn -> .acr)
# and the main glossary (.glo -> .gls) are generated during every latexmk build.
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');
add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
$clean_ext .= ' acr acn alg glo gls glg ist';

sub run_makeglossaries {
    my ($base_name, $path) = fileparse($_[0]);
    my @args = ('-q', $base_name);
    if ($path ne '') { unshift @args, '-d', $path; }
    return system('makeglossaries', @args);
}
