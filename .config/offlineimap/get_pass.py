#! /usr/bin/env python

import dataclasses as dc
import getpass, json, os

CREDSFILE = os.path.expanduser("~/.local/share/offlineimap/creds")


@dc.dataclass
class Account:
    account: str
    email: str
    password: str


class EnhancedJSONEncoder(json.JSONEncoder):
    def default(self, o):
        if dc.is_dataclass(o):
            return dc.asdict(o)
        return super().default(o)


def get_account(account: str):
    creds = read_file()
    return creds[account]


def get_pass(account: str):
    return get_account(account).password


def get_email(account: str):
    return get_account(account).email


def print_account(account: str):
    print(get_account(account))


# for use with mutt
def print_pass(account: str):
    print(get_account(account).password)


def add_account(account: str):
    try:
        creds = read_file()
    except FileNotFoundError as e:
        creds = {}
    email = input("Enter email addr: ")
    passwd = getpass.getpass()
    creds[account] = Account(account, email, passwd)
    write_file(creds)


def del_account(account: str):
    creds = read_file()
    del creds[account]
    write_file(creds)


def read_file():
    with open(CREDSFILE, "r") as credsfile:
        json_creds = json.load(credsfile)
    creds = {
        k: Account(v["account"], v["email"], v["password"])
        for k, v in json_creds.items()
    }
    return creds


def write_file(creds):
    credsfile_temp = os.path.expanduser(f"{CREDSFILE}.temp")
    with open(credsfile_temp, "w") as credsfile:
        json.dump(creds, credsfile, cls=EnhancedJSONEncoder)
    os.rename(credsfile_temp, CREDSFILE)


if __name__ == "__main__":
    import sys

    globals()[sys.argv[1]](*sys.argv[2:])
