package  Text::Smarty::Parser;
use strict;
use warnings;
use IO::String;
use Params::Validate qw();
use Text::Smarty::Parser::Token::Variable;
use Text::Smarty::Parser::Token::Comment;
use Text::Smarty::Parser::Token::IF;
use Text::Smarty::Parser::Token::ELSE;
use Text::Smarty::Parser::Token::ENDIF;

sub new {
    my $class = shift;

    my %options = Params::Validate::validate(@_, +{
        delim_start => { default => "{" },
        delim_end   => { default => "}" },
    });

    my $self = \%options;
    bless $self, $class;
}

sub parse {
    my ($self, $text) = @_;

    my $io_text = IO::String->new($text);
    my @result;
    my $is_in_tag;
    my $token_buffer = "";
    while ( my $c = getc $io_text ) {
        if ( $is_in_tag ) {
            if ( $c eq $self->{delim_end} ) {
                push @result, $self->_handle_tag($token_buffer);
                $token_buffer = "";
                $is_in_tag--;
            } else {
                $token_buffer .= $c;
            }
        } else {
            if ( $c eq $self->{delim_start} ) {
                push @result, $token_buffer;
                $token_buffer = "";
                $is_in_tag++;
            } else {
                $token_buffer .= $c;
            }
        }
    }
    push @result, $token_buffer;
    return \@result;
}

sub _handle_tag {
    my ($self, $tag) = @_;

    $tag =~ s/^\s*(.+)\s*$/$1/;
    if ( $tag =~ /^\$(.+)$/ ) {
        return Text::Smarty::Parser::Token::Variable->new(name => $1);
    } else {
        if ( $tag =~ /^if (.+)$/ ) {
            return Text::Smarty::Parser::Token::IF->new(cond => [$1]);
        } elsif ( $tag eq 'else' ) {
            return Text::Smarty::Parser::Token::ELSE->new();
        } elsif ( $tag eq '/if' ) {
            return Text::Smarty::Parser::Token::ENDIF->new();
        } elsif ( $tag =~ m/^\*\s*([^\*]+?)\s*\*$/ ) {
            return Text::Smarty::Parser::Token::Comment->new(comment => $1);
        }
    }

    return $tag;
}


1;
__END__
=head2 NAME

Text::Smarty::Parser

=head2 SYNOPSIS

    my $parser = Text::Smarty::Parser->new(%option);
    my $result = $parser->parse("text");

