package  Text::Smarty::Parser::Token::ENDIF;
use strict;
use warnings;
use base qw(Text::Smarty::Parser::Token);

sub new {
    my ($class, %args) = @_;

    bless \%args, $class;
}

1;
