package  Text::Smarty::Parser::Token::EndFunction;
use strict;
use warnings;
use base qw(Text::Smarty::Parser::Token);

sub new {
    my ($class, %args) = @_;

    bless \%args, $class;
}

sub name { $_[0]->{name} }

1;
