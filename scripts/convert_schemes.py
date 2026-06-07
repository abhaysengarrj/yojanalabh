import json
import os
from datetime import datetime

SCHEMES_PATH = os.path.join(
    os.path.dirname(os.path.dirname(__file__)),
    'assets', 'schemes', 'schemes_v1.json'
)
VERSION_PATH = os.path.join(
    os.path.dirname(os.path.dirname(__file__)),
    'version.txt'
)

HUggingFACE_DATASET = (
    "https://huggingface.co/datasets/your-username/india-gov-schemes"
)

def load_current_version():
    if not os.path.exists(VERSION_PATH):
        return 1
    with open(VERSION_PATH, 'r') as f:
        return int(f.read().strip())

def save_version(version):
    with open(VERSION_PATH, 'w') as f:
        f.write(str(version))

def convert_huggingface_row(row):
    """Convert a HuggingFace dataset row to app scheme format."""
    eligibility = {}
    if row.get('min_age'): eligibility['minAge'] = int(row['min_age'])
    if row.get('max_age'): eligibility['maxAge'] = int(row['max_age'])
    if row.get('max_income'): eligibility['maxAnnualIncome'] = float(row['max_income'])
    if row.get('occupation'): eligibility['occupation'] = row['occupation']
    if row.get('caste'): eligibility['caste'] = row['caste']
    if row.get('gender'): eligibility['gender'] = row['gender']
    if row.get('state'): eligibility['state'] = row['state']

    return {
        'name': row.get('name', ''),
        'description': row.get('description', ''),
        'ministry': row.get('ministry', ''),
        'applyLink': row.get('apply_link', ''),
        'category': row.get('category', 'अन्य'),
        'eligibility': eligibility,
    }

def main():
    current_version = load_current_version()
    new_version = current_version + 1

    try:
        import requests
        from bs4 import BeautifulSoup

        all_schemes = []
        seen_names = set()

        try:
            resp = requests.get(
                "https://www.myscheme.gov.in/sitemap.xml",
                timeout=15
            )
            if resp.status_code == 200:
                soup = BeautifulSoup(resp.content, 'xml')
                urls = soup.find_all('loc')
                for url in urls:
                    text = url.text.strip()
                    if '/schemes/' in text:
                        all_schemes.append({
                            'name': text.split('/')[-1].replace('-', ' ').title(),
                            'description': 'See official website for details.',
                            'ministry': '',
                            'applyLink': text,
                            'category': 'अन्य',
                            'eligibility': {},
                        })
                        seen_names.add(text.split('/')[-1])
        except Exception:
            pass

        if all_schemes:
            with open(SCHEMES_PATH, 'r', encoding='utf-8') as f:
                existing = json.load(f)

            existing_names = {s['name'] for s in existing['schemes']}
            for scheme in all_schemes:
                if scheme['name'] not in existing_names:
                    existing['schemes'].append(scheme)
                    existing_names.add(scheme['name'])

            existing['latestVersion'] = new_version
            with open(SCHEMES_PATH, 'w', encoding='utf-8') as f:
                json.dump(existing, f, ensure_ascii=False, indent=2)

            save_version(new_version)
            print(f"Updated to version {new_version} with {len(existing['schemes'])} schemes")
        else:
            print(f"No new schemes found. Current version: {current_version}")

    except ImportError:
        print("requests/bs4 not installed, skipping scrape")
        pass

if __name__ == '__main__':
    main()
