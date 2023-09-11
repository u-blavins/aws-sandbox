import boto3

from boto3_type_annotations.events import Client

EVENT_BUS = "test-message-bus"


def get_events_client() -> Client:
    return boto3.client("events")


def list_all_event_buses(client: Client, limit: int = 100):
    return client.list_event_buses(Limit=limit)


def put_event(client: Client, entries: list):
    return client.put_events(Entries=entries)


def generate_events(events: int = 1):
    entries = []
    for i in range(events):
        entries.append({
            "Source": "ub-local-machine",
            "Resources": [
                "awscli",
            ],
            "DetailType": "random-generated-event",
            "Detail": "{}",
            "EventBusName": EVENT_BUS
        })
    return entries


def main():
    client = get_events_client()
    entries = generate_events()
    print(put_event(client, entries))
    return 0


if __name__ == "__main__":
    main()
