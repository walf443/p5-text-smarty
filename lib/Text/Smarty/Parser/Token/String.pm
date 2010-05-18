package  Text::Smarty::Parser::Token::String;
use strict;
use warnings;
use base qw(Text::Smarty::Parser::Token);
use overload '""' => \&string;

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

sub string { $_[0]->{string} }

1;
