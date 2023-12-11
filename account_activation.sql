select *
from (with subs as
               (select distinct case
                                    when ss.argus_direct_user_id is null then ss.subscriber_user_id
                                    else ss.argus_direct_user_id end      as subscriber_user_id,
                                ss.contact_id                             as contact_id,
                                ss.fullname                               as fullname,
                                ss.subscriber_job_title,
                                lower(ss.delivery_email)                  as delivery_email,
                                upper(ss.subscriber_company_name)         as company,
                                ss.subscriber_country,
                                ss.customer_av_segmentation               AS segmentation,
                                case
                                    when ss.subscriber_sales_rep_name is null then cc.customer_sales_rep_name
                                    else ss.subscriber_sales_rep_name end as account_manager
                from subscription.subscribers ss
                         left join
                     (select *
                      from customer.customers
                      where customer_sales_rep_name is not null) as cc
                     on ss.subscriber_company_name = cc.company_name)
      select subs.account_manager,
             subs.contact_id,
             subs.fullname,
             subs.company,
             customer as email,
             email_domain,
             user_id,
             email_ref,
             event_time,
             event,
             email_type,
             content
      from business_event.mv_misuse_event_new mis
      join subs on subs.delivery_email = mis.customer)
where email_type = 'My Account'
  and content in ('Argus Account Activated', 'Argus Account Activation');