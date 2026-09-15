# ============================================================
# FARMORA MARKET DATA SCHEDULER
# Automatically updates market prices
# ============================================================


import time
import schedule

from live_market_updater import update_all_market_data



# ============================================================
# JOB FUNCTION
# ============================================================


def market_update_job():

    print("\n")
    print("=" * 60)
    print("Starting scheduled market update")
    print("=" * 60)


    try:

        update_all_market_data()


        print(
            "Scheduled update completed successfully"
        )


    except Exception as e:


        print(
            "Scheduled update failed:",
            e
        )



# ============================================================
# SCHEDULE CONFIGURATION
# ============================================================


# Every day at 6 AM

schedule.every().day.at(
    "06:00"
).do(
    market_update_job
)



print(
    "Farmora Scheduler Started"
)


print(
    "Waiting for scheduled updates..."
)



# ============================================================
# RUN LOOP
# ============================================================


while True:


    schedule.run_pending()


    time.sleep(
        60
    )