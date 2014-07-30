from jinja import Environment, FileSystemLoader
import sqlite3


class State():
    abbr_dict = {"WA": "WASHINGTON",
                 "VA": "VIRGINIA",
                 "DE": "DELAWARE",
                 "DC": "DISTRICT OF COLUMBIA",
                 "WI": "WISCONSIN",
                 "WV": "WEST VIRGINIA",
                 "HI": "HAWAII",
                 "AE": "Armed Forces Middle East",
                 "FL": "FLORIDA",
                 "FM": "FEDERATED STATES OF MICRONESIA",
                 "WY": "WYOMING",
                 "NH": "NEW HAMPSHIRE",
                 "NJ": "NEW JERSEY",
                 "NM": "NEW MEXICO",
                 "TX": "TEXAS",
                 "LA": "LOUISIANA",
                 "NC": "NORTH CAROLINA",
                 "ND": "NORTH DAKOTA",
                 "NE": "NEBRASKA",
                 "TN": "TENNESSEE",
                 "NY": "NEW YORK",
                 "PA": "PENNSYLVANIA",
                 "CA": "CALIFORNIA",
                 "NV": "NEVADA",
                 "AA": "Armed Forces Americas",
                 "PW": "PALAU",
                 "GU": "GUAM",
                 "CO": "COLORADO",
                 "VI": "VIRGIN ISLANDS",
                 "AK": "ALASKA",
                 "AL": "ALABAMA",
                 "AP": "Armed Forces Pacific",
                 "AS": "AMERICAN SAMOA",
                 "AR": "ARKANSAS",
                 "VT": "VERMONT",
                 "IL": "ILLINOIS",
                 "GA": "GEORGIA",
                 "IN": "INDIANA",
                 "IA": "IOWA",
                 "OK": "OKLAHOMA",
                 "AZ": "ARIZONA",
                 "ID": "IDAHO",
                 "CT": "CONNECTICUT",
                 "ME": "MAINE",
                 "MD": "MARYLAND",
                 "MA": "MASSACHUSETTS",
                 "OH": "OHIO",
                 "UT": "UTAH",
                 "MO": "MISSOURI",
                 "MN": "MINNESOTA",
                 "MI": "MICHIGAN",
                 "MH": "MARSHALL ISLANDS",
                 "RI": "RHODE ISLAND",
                 "KS": "KANSAS",
                 "MT": "MONTANA",
                 "MP": "NORTHERN MARIANA ISLANDS",
                 "MS": "MISSISSIPPI",
                 "PR": "PUERTO RICO",
                 "SC": "SOUTH CAROLINA",
                 "KY": "KENTUCKY",
                 "OR": "OREGON",
                 "SD": "SOUTH DAKOTA"
                 }

    abbreviation = "PA"
    name = abbr_dict["PA"].capitalize()
    judicial_election_type = "moo"
    average_donation = "moo"
    ranking_blurb = "moo"
    total_contributions = "moo"
    # probably just a list of tuples (name, amount)
    contribution_recipients = []
    contributors = []
    contributing_industries = []

env = Environment(loader=FileSystemLoader('templates'))
template = env.get_template('state.html')
db = sqlite3.connect('data/state_judicial.sqlite').cursor()
#print template.render(state=State())
