import json
import os


def get_config():
    with open("secrets-config.json", 'r') as f:
        data = json.load(f)
    return data


def banner(items, prevent_all_option=False):
    for i, item in enumerate(items):
        print("{}. {}".format(i + 1, item))
    if not prevent_all_option and len(items) > 1:
        print("{}. All".format(len(items) + 1))
    return items


def get_response(prompt, items, prevent_all_option=False):
    print()
    value = input(prompt)
    if value not in [str(x + 1) for x in range(len(items) + 1 if (not prevent_all_option and len(items) > 1)
                                               else len(items))]:
        print("{} is not a valid choice.".format(value))
        return get_response(prompt, items)
    if int(value) == len(items) + 1:
        raise Exception("{} is not a valid choice.".format(value))
    return int(value)


def question_banner(title, first=False):
    if not first:
        print()
    print("===========================================")
    print(f"{title}: ")
    print("===========================================")


if __name__ == '__main__':
    question_banner("Available Stacks", True)
    stacks = banner(['local', 'dev', 'staging', 'prod'], prevent_all_option=True)
    stack = stacks[get_response("Which Stack would you like to configure?: ", stacks) - 1]

    secrets_path = os.path.abspath(
        os.path.join(os.path.dirname(os.path.abspath(__file__)), 'kustomize', 'overlays', stack, 'secrets'))
    if not os.path.exists(secrets_path):
        os.makedirs(secrets_path)

    question_banner(f"Set ({stack}) secrets by answering the following questions")
    for secret in get_config():
        value = input(f"{secret['question']}: ")
        with open(f"{secrets_path}/{secret['key']}.txt", 'w+') as f:
            f.write(value)

