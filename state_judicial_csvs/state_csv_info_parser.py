import csv
import glob
from datetime import datetime
from operator import itemgetter
import locale
locale.setlocale(locale.LC_ALL, '')

# All info needed:
# Total donated since 2000
# Average donation
# Total lower-court contributions
# Top 5 recipients since 2000 (and amount)
# Top 5 donors since 2000 (and amount)
# Top 5 contributing industries since 2000 (and amount)
# Top 5 lower court recipients (and amount)
# Top 5 lower court donors (and amount)
# Top 5 lower court donating industries (and amount)

class StateInfo(object):

    def __init__(self, state_info):
        self.state_info = state_info
        self.all_donations = [int(line["Amount"]) for line in state_info]
        self.donations_since_2000 = self._setup_donations_c_2000(state_info)
        self.lower_court = [
                            line for line in state_info
                            if line["RecipientOffice"] != "SUPCOURT"
                           ]

    def _setup_donations_c_2000(self, state_info):
        ary = []
        for line in state_info:
            if line["Date"]:
                date_donated = datetime.strptime(line["Date"], "%m/%d/%y")
                if date_donated.year > 2000:
                    ary.append(int(line["Amount"]))
        return ary

    def total_donated_since_2000(self):
        return sum(self.donations_since_2000)

    def average_donation(self):
        return float(sum(self.all_donations) / len(self.all_donations))

    def total_lower_court_contributions(self):
        return sum([int(x["Amount"]) for x in self.lower_court])

    def top5_for_key_and_collection(self, key, collection, reverse_order=True):
        ranking = {}
        for line in collection:
            if line[key] in ranking:
                ranking[line[key]] += int(line["Amount"])
            else:
                ranking[line[key]] = 0
        return sorted(ranking.iteritems(),
                key=itemgetter(1),
                reverse=reverse_order
                )[:5]

    def top5_recipients_with_amount(self):
        recipients = {}
        for line in self.lower_court:
            if line["RecipientName"] in recipients:
                recipients[line["RecipientName"]] += int(line["Amount"])
            else:
                recipients[line["RecipientName"]] = 0
        return sorted(recipients.iteritems(),
                key=itemgetter(1),
                reverse=True
                )[:5]


if __name__ == "__main__":
    def list_str(lt): return ", ".join([ t[0].title() for t in lt])
    def list_num(lt): return ", ".join([ str(t[1]) for t in lt])
    csv_output = csv.writer(open('allstates.csv', 'wb'), delimiter=',')
    csv_output.writerow([
        "State",
        "Total donated since 2000",
        "Average donation",
        "Total lower-court contributions",
        "Top 5 recipients since 2000",
        "Amount from recipient",
        "Top 5 donors since 2000",
        "Amount from donor",
        "Top 5 contributing industries since 2000",
        "Amount from industry",
        "Top 5 lower court recipients",
        "Amount from lower court recipient",
        "Top 5 lower court donors",
        "Amount from lower court donor",
        "Top 5 lower court donating industries",
        "Amount from lower court donor industry"
    ])
    csv_files = glob.glob("??.csv")
    for csv_path in csv_files:
        csv_dict = csv.DictReader(open(csv_path), delimiter=',')
        state = StateInfo(list(csv_dict))
        recipients = state.top5_for_key_and_collection("RecipientName", state.state_info)

        donor = state.top5_for_key_and_collection("Contributor", state.state_info)
        industry = state.top5_for_key_and_collection("Industry", state.state_info)
        lc_recipients = state.top5_for_key_and_collection("RecipientName", state.lower_court)
        lc_donor = state.top5_for_key_and_collection("Contributor", state.lower_court)
        lc_industry = state.top5_for_key_and_collection("Industry", state.lower_court)
        csv_output.writerow([
            csv_path,
            state.total_donated_since_2000(),
            state.average_donation(),
            state.total_lower_court_contributions(),
            list_str(recipients),
            list_num(recipients),
            list_str(donor),
            list_num(donor),
            list_str(industry),
            list_num(industry),
            list_str(lc_recipients),
            list_num(lc_recipients),
            list_str(lc_donor),
            list_num(lc_donor),
            list_str(lc_industry),
            list_num(lc_industry),
            ])
