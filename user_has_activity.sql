select distinct delivery_email, 
				max(event_date) as last_active_date, 
				'Yes' as has_engaged_on_platforms
from business_event.platform_usage
group by 1;