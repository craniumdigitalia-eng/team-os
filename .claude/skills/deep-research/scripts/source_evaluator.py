#!/usr/bin/env python3
"""
Source Credibility Evaluator
Assesses source quality, credibility, and potential biases
"""

from dataclasses import dataclass
from typing import List, Dict, Optional
from urllib.parse import urlparse
from datetime import datetime, timedelta
import re


@dataclass
class CredibilityScore:
    """Represents source credibility assessment"""
    overall_score: float  # 0-100
    domain_authority: float  # 0-100
    recency: float  # 0-100
    expertise: float  # 0-100
    bias_score: float  # 0-100 (higher = more neutral)
    factors: Dict[str, str]
    recommendation: str  # "high_trust", "moderate_trust", "low_trust", "verify"


class SourceEvaluator:
    """Evaluates source credibility and quality"""

    # Domain reputation tiers
    HIGH_AUTHORITY_DOMAINS = {
        # Academic & Research
        'arxiv.org', 'nature.com', 'science.org', 'cell.com', 'nejm.org',
        'thelancet.com', 'springer.com', 'sciencedirect.com', 'plos.org',
        'ieee.org', 'acm.org', 'pubmed.ncbi.nlm.nih.gov',

        # Government & International Organizations
        'nih.gov', 'cdc.gov', 'who.int', 'fda.gov', 'nasa.gov',
        'gov.uk', 'europa.eu', 'un.org',

        # Established Tech Documentation
        'docs.python.org', 'developer.mozilla.org', 'docs.microsoft.com',
        'cloud.google.com', 'aws.amazon.com', 'kubernetes.io',

        # Reputable News (Fact-check verified)
        'reuters.com', 'apnews.com', 'bbc.com', 'economist.com',
        'scientificamerican.com',

        # Brasil — fontes oficiais (governo, judiciário, legislativo, estatística)
        'gov.br', 'jus.br', 'leg.br', 'bcb.gov.br', 'ibge.gov.br',
        'ipea.gov.br', 'planalto.gov.br', 'stf.jus.br', 'stj.jus.br',
        'camara.leg.br', 'senado.leg.br', 'cvm.gov.br', 'anpd.gov.br'
    }

    # Sufixos oficiais que recebem nota máxima de domínio (casam por sufixo)
    OFFICIAL_SUFFIXES = ('gov', 'gov.br', 'jus.br', 'leg.br', 'mil.br', 'mp.br', 'gov.uk', 'europa.eu', 'int')

    MODERATE_AUTHORITY_DOMAINS = {
        # Tech News & Analysis
        'techcrunch.com', 'theverge.com', 'arstechnica.com', 'wired.com',
        'zdnet.com', 'cnet.com',

        # Industry Publications
        'forbes.com', 'bloomberg.com', 'wsj.com', 'ft.com',

        # Educational
        'wikipedia.org', 'britannica.com', 'khanacademy.org',

        # Tech Blogs (established)
        'medium.com', 'dev.to', 'stackoverflow.com', 'github.com'
    }

    LOW_AUTHORITY_INDICATORS = [
        'blogspot.com', 'wordpress.com', 'wix.com', 'substack.com'
    ]

    def __init__(self):
        pass

    def evaluate_source(
        self,
        url: str,
        title: str,
        content: Optional[str] = None,
        publication_date: Optional[str] = None,
        author: Optional[str] = None
    ) -> CredibilityScore:
        """Evaluate source credibility"""

        domain = self._extract_domain(url)

        # Calculate component scores
        domain_score = self._evaluate_domain_authority(domain)
        recency_score = self._evaluate_recency(publication_date)
        expertise_score = self._evaluate_expertise(domain, title, author)
        bias_score = self._evaluate_bias(domain, title, content)

        # Calculate overall score (weighted average)
        overall = (
            domain_score * 0.35 +
            recency_score * 0.20 +
            expertise_score * 0.25 +
            bias_score * 0.20
        )

        # Determine factors
        factors = self._identify_factors(
            domain, domain_score, recency_score, expertise_score, bias_score
        )

        # Generate recommendation
        recommendation = self._generate_recommendation(overall)

        return CredibilityScore(
            overall_score=round(overall, 2),
            domain_authority=round(domain_score, 2),
            recency=round(recency_score, 2),
            expertise=round(expertise_score, 2),
            bias_score=round(bias_score, 2),
            factors=factors,
            recommendation=recommendation
        )

    def _extract_domain(self, url: str) -> str:
        """Extract domain from URL (sem porta, sem www.)"""
        if '://' not in url:
            url = 'https://' + url
        domain = (urlparse(url).hostname or '').lower().rstrip('.')
        if domain.startswith('www.'):
            domain = domain[4:]
        return domain

    @staticmethod
    def _matches(domain: str, candidates) -> Optional[str]:
        """Casa por sufixo de domínio: 'agenciadenoticias.ibge.gov.br' casa 'ibge.gov.br'."""
        best = None
        for c in candidates:
            if domain == c or domain.endswith('.' + c):
                if best is None or len(c) > len(best):
                    best = c
        return best

    def _is_official(self, domain: str) -> bool:
        return self._matches(domain, self.OFFICIAL_SUFFIXES) is not None

    def _evaluate_domain_authority(self, domain: str) -> float:
        """Evaluate domain authority (0-100)"""
        if self._is_official(domain):
            return 95.0
        if self._matches(domain, self.HIGH_AUTHORITY_DOMAINS):
            return 90.0
        elif self._matches(domain, self.MODERATE_AUTHORITY_DOMAINS):
            return 70.0
        elif self._matches(domain, self.LOW_AUTHORITY_INDICATORS):
            return 40.0
        else:
            # Unknown domain - moderate skepticism
            return 55.0

    def _evaluate_recency(self, publication_date: Optional[str]) -> float:
        """Evaluate information recency (0-100)"""
        if not publication_date:
            return 50.0  # Unknown date

        try:
            pub_date = datetime.fromisoformat(publication_date.replace('Z', '+00:00'))
            age = datetime.now() - pub_date

            # Recency scoring
            if age < timedelta(days=90):  # < 3 months
                return 100.0
            elif age < timedelta(days=365):  # < 1 year
                return 85.0
            elif age < timedelta(days=730):  # < 2 years
                return 70.0
            elif age < timedelta(days=1825):  # < 5 years
                return 50.0
            else:
                return 30.0

        except Exception:
            return 50.0

    def _evaluate_expertise(
        self,
        domain: str,
        title: str,
        author: Optional[str]
    ) -> float:
        """Evaluate source expertise (0-100)"""
        score = 50.0

        # Academic/research domains get high expertise
        if any(d in domain for d in ['arxiv', 'nature', 'science', 'ieee', 'acm']):
            score += 30

        # Government/official sources (inclui .gov.br, .jus.br, .leg.br)
        if self._is_official(domain):
            score += 25

        # Technical documentation
        if 'docs.' in domain or 'documentation' in title.lower():
            score += 20

        # Author credentials (if available)
        if author:
            if any(title in author.lower() for title in ['dr.', 'phd', 'professor']):
                score += 15

        return min(score, 100.0)

    def _evaluate_bias(
        self,
        domain: str,
        title: str,
        content: Optional[str]
    ) -> float:
        """Evaluate potential bias (0-100, higher = more neutral)"""
        score = 70.0  # Start neutral

        # Check for sensationalism in title
        sensational_indicators = [
            '!', 'shocking', 'unbelievable', 'you won\'t believe',
            'secret', 'they don\'t want you to know'
        ]
        title_lower = title.lower()
        if any(indicator in title_lower for indicator in sensational_indicators):
            score -= 20

        # Academic sources are typically less biased
        if any(d in domain for d in ['arxiv', 'nature', 'science', 'ieee']):
            score += 20

        # Check for balance in content (if available)
        if content:
            # Look for balanced language
            balanced_indicators = ['however', 'although', 'on the other hand', 'critics argue']
            if any(indicator in content.lower() for indicator in balanced_indicators):
                score += 10

        return min(max(score, 0), 100.0)

    def _identify_factors(
        self,
        domain: str,
        domain_score: float,
        recency_score: float,
        expertise_score: float,
        bias_score: float
    ) -> Dict[str, str]:
        """Identify key credibility factors"""
        factors = {}

        if self._is_official(domain):
            factors['domain'] = "Official source (government/judiciary/legislature)"
        elif domain_score >= 85:
            factors['domain'] = "High authority domain"
        elif domain_score <= 45:
            factors['domain'] = "Low authority domain - verify claims"

        if recency_score >= 85:
            factors['recency'] = "Recent information"
        elif recency_score <= 40:
            factors['recency'] = "Outdated information - verify currency"

        if expertise_score >= 80:
            factors['expertise'] = "Expert source"
        elif expertise_score <= 45:
            factors['expertise'] = "Limited expertise indicators"

        if bias_score >= 80:
            factors['bias'] = "Balanced perspective"
        elif bias_score <= 50:
            factors['bias'] = "Potential bias detected"

        return factors

    def _generate_recommendation(self, overall_score: float) -> str:
        """Generate trust recommendation"""
        if overall_score >= 80:
            return "high_trust"
        elif overall_score >= 60:
            return "moderate_trust"
        elif overall_score >= 40:
            return "low_trust"
        else:
            return "verify"


def main(argv: Optional[List[str]] = None) -> int:
    import argparse
    parser = argparse.ArgumentParser(
        description="Nota de credibilidade (0-100) de uma ou mais URLs, com o motivo. Só stdlib, sem rede."
    )
    parser.add_argument('urls', nargs='+', help='URL(s) a avaliar')
    parser.add_argument('--title', default='', help='Título da fonte (opcional, vale para todas)')
    parser.add_argument('--date', default=None, help='Data de publicação ISO (AAAA-MM-DD), opcional')
    parser.add_argument('--author', default=None, help='Autor (opcional)')
    args = parser.parse_args(argv)

    evaluator = SourceEvaluator()
    for url in args.urls:
        r = evaluator.evaluate_source(url, args.title, publication_date=args.date, author=args.author)
        reasons = '; '.join(r.factors.values()) or 'sem sinais fortes'
        print(f"{r.overall_score:5.1f}  {r.recommendation:<14}  {url}  — dominio={r.domain_authority:.0f}; {reasons}")
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
