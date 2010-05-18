package  Text::Smarty::Parser::Token::Comment;
use strict;
use warnings;
use base qw(Text::Smarty::Parser::Token);

sub new {
    my ($class, %args) = @_;

    bless \%args, $class;
}

sub comment { $_[0]->{comment} }

1;
