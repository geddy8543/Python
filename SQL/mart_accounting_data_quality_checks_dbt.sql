with
    cte_bright_policies as (
        select
            dim_policies.bright_policy_id,
            dim_policies.term,
            dim_policies.policy_status,
            dim_policies.cancellation_created_datetime,
            dim_policies.cancellation_effective_date,
            dim_policies.cancellation_status,
            dim_policies.cancellation_category,
            dim_policies.cancellation_reason,
            dim_policies.nonrenewal_created_datetime,
            dim_policies.nonrenewal_effective_date,
            dim_policies.nonrenewal_status,
            dim_policies.nonrenewal_category,
            dim_policies.nonrenewal_reason,
            dim_policies.pending_endorsement_flag,
            dim_policies.in_progress_endorsement_request_flag,
            dim_addresses.state,
            dim_products.product_type,
            dim_products.product_line,
            dim_insurance_carriers.insurance_carrier_name as carrier_name,
            dotcom_bright_policies_bronze.deleted_at as bright_policy_deleted_at
        from {{ ref("dim_policies_gold") }} dim_policies
        inner join
            {{ ref("dim_properties_gold") }} dim_properties
            on dim_policies.property_id = dim_properties.property_id
        inner join
            {{ ref("dim_addresses_gold") }} dim_addresses
            on dim_properties.address_id = dim_addresses.address_id
        inner join
            {{ ref("dim_products_gold") }} dim_products
            on dim_policies.product_id = dim_products.product_id
        inner join
            {{ ref("dim_insurance_carriers_gold") }} dim_insurance_carriers
            on dim_products.insurance_carrier_id
            = dim_insurance_carriers.insurance_carrier_id
        inner join
            {{ ref("dotcom_bright_policies_bronze") }} dotcom_bright_policies_bronze
            on dim_policies.bright_policy_id = dotcom_bright_policies_bronze.id
        where 1 = 1
    ),
    cte_checks_step_one as (
        select
            a.bright_policy_id,
            a.term,
            a.mart_accounting_agg_key,
            a.effective_date,
            a.expiration_date,
            a.final_term_date,
            a.property_id,
            a.product_id,
            a.coverage_id,
            a.frozen_rating_id,
            a.full_policy_number,
            a.payment_schedule,
            a.payment_type,
            a.accounting_ledger_earned_surplus,
            a.accounting_ledger_premium_charge_off,
            a.accounting_ledger_fee_revenue,
            a.accounting_ledger_inspection_fees,
            a.accounting_ledger_program_administrator_fee_revenue,
            a.accounting_ledger_direct_premiums_written,
            a.accounting_ledger_change_in_unearned_premium_reserve,
            a.accounting_ledger_state_tax_revenue,
            a.accounting_ledger_state_tax_charge_off,
            a.accounting_ledger_figa_fee_revenue,
            a.accounting_ledger_figa_fee_charge_off,
            a.accounting_ledger_refunds_payable,
            a.accounting_ledger_empa_fee_payable,
            a.accounting_ledger_unearned_premium_reserve,
            a.accounting_ledger_premiums_received_in_advanced,
            a.accounting_ledger_unearned_surplus,
            a.accounting_ledger_state_tax_1_payable,
            a.accounting_ledger_state_tax_2_payable,
            a.accounting_ledger_state_tax_3_payable,
            a.accounting_ledger_premium_tax_deduction_payable,
            a.accounting_ledger_fire_marshal_tax_deduction_payable,
            a.accounting_ledger_premium_receivable,
            a.accounting_ledger_deferred_installments,
            a.accounting_ledger_cash,
            a.accounting_ledger_unapplied_cash,
            a.accounting_ledger_state_tax_receivable,
            a.accounting_ledger_figa_fee_receivable,
            a.accounting_ledger_suspense_account,
            a.accounting_ledger_state_tax_1_receivable,
            a.accounting_ledger_state_tax_2_receivable,
            a.accounting_ledger_state_tax_3_receivable,
            a.accounting_ledger_state_tax_1_charge_off,
            a.accounting_ledger_state_tax_2_charge_off,
            a.accounting_ledger_state_tax_3_charge_off,
            a.accounting_ledger_unassigned_surplus,
            a.billing_total_amount_dollar_amount,
            a.billing_upcoming_amount_dollar_amount,
            a.billing_approved_amount_dollar_amount,
            a.billing_total_accounting_premium_dollar_amount,
            a.billing_upcoming_accounting_premium_dollar_amount,
            a.billing_approved_accounting_premium_dollar_amount,
            a.billing_total_empa_fee_dollar_amount,
            a.billing_upcoming_empa_fee_dollar_amount,
            a.billing_approved_empa_fee_dollar_amount,
            a.billing_total_figa_fee_dollar_amount,
            a.billing_upcoming_figa_fee_dollar_amount,
            a.billing_approved_figa_fee_dollar_amount,
            a.billing_total_inspection_fee_dollar_amount,
            a.billing_upcoming_inspection_fee_dollar_amount,
            a.billing_approved_inspection_fee_dollar_amount,
            a.billing_total_installment_fee_dollar_amount,
            a.billing_upcoming_installment,
            a.billing_approved_installment_fee_dollar_amount,
            a.billing_total_program_administrator_fee_dollar_amount,
            a.billing_upcoming_program_administrator_fee_dollar_amount,
            a.billing_approved_program_administrator_fee_dollar_amount,
            a.billing_total_refunds_payable_dollar_amount,
            a.billing_upcoming_refunds,
            a.billing_approved_refunds_payable_dollar_amount,
            a.billing_total_state_tax_dollar_amount,
            a.billing_upcoming_state_tax_dollar_amount,
            a.billing_approved_state_tax_dollar_amount,
            a.billing_total_state_tax_1_dollar_amount,
            a.billing_upcoming_state_tax_1_dollar_amount,
            a.billing_approved_state_tax_1_dollar_amount,
            a.billing_total_state_tax_2_dollar_amount,
            a.billing_upcoming_state_tax_2_dollar_amount,
            a.billing_approved_state_tax_2_dollar_amount,
            a.billing_total_state_tax_3_dollar_amount,
            a.billing_upcoming_state_tax_3_dollar_amount,
            a.billing_approved_state_tax_3_dollar_amount,
            a.billing_total_surplus_dollar_amount,
            a.billing_upcoming_surplus_dollar_amount,
            a.billing_approved_surplus_dollar_amount,
            a.policy_transactions_total_written_premium_amount,
            a.policy_transactions_hurricane_written_premium_amount,
            a.policy_transactions_fire_written_premium_amount,
            a.policy_transactions_flood_written_premium_amount,
            a.policy_transactions_earthquake_written_premium_amount,
            a.policy_transactions_wild_fire_written_premium_amount,
            a.policy_transactions_winter_storm_written_premium_amount,
            a.policy_transactions_severe_convective_storm_written_premium_amount,
            a.policy_transactions_all_other_perils_written_premium_amount,
            a.policy_transactions_additional_surplus_and_fees_written_premium_amount,
            a.policy_transactions_surplus_written_premium_amount,
            a.policy_transactions_surcharge_written_premium_amount,
            a.policy_transactions_state_tax_written_premium_amount,
            a.policy_transactions_state_tax_1_written_premium_amount,
            a.policy_transactions_state_tax_2_written_premium_amount,
            a.policy_transactions_state_tax_3_written_premium_amount,
            a.policy_transactions_premium_tax_deduction_written_premium_amount,
            a.policy_transactions_fire_marshal_tax_deduction_written_premium_amount,
            a.policy_transactions_mga_fee_written_premium_amount,
            a.policy_transactions_installment_fee_written_premium_amount,
            a.policy_transactions_inspection_fee_written_premium_amount,
            a.policy_transactions_empt_fee_written_premium_amount,
            a.policy_transactions_figa_recoupment_written_premium_amount,
            a.policy_transactions_total_earned_premium_amount,
            a.policy_transactions_hurricane_earned_premium_amount,
            a.policy_transactions_fire_earned_premium_amount,
            a.policy_transactions_flood_earned_premium_amount,
            a.policy_transactions_earthquake_earned_premium_amount,
            a.policy_transactions_wild_fire_earned_premium_amount,
            a.policy_transactions_winter_storm_earned_premium_amount,
            a.policy_transactions_severe_convective_storm_earned_premium_amount,
            a.policy_transactions_all_other_perils_earned_premium_amount,
            a.policy_transactions_additional_surplus_and_fees_earned_premium_amount,
            a.policy_transactions_surplus_earned_premium_amount,
            a.policy_transactions_surcharge_earned_premium_amount,
            a.policy_transactions_state_tax_earned_premium_amount,
            a.policy_transactions_state_tax_1_earned_premium_amount,
            a.policy_transactions_state_tax_2_earned_premium_amount,
            a.policy_transactions_state_tax_3_earned_premium_amount,
            a.policy_transactions_premium_tax_deduction_earned_premium_amount,
            a.policy_transactions_fire_marshal_tax_deduction_earned_premium_amount,
            a.policy_transactions_mga_fee_earned_premium_amount,
            a.policy_transactions_figa_recoupment_earned_premium_amount,
            -- -- ONCE THESE VALUES ARE ADDED TO GOLD TABLE - REPLACE WITH ALIAS
            -- REFERENCE
            0 as reporting_rejected_total_amount_sum,
            0 as reporting_rejected_premium_sum,
            0 as reporting_refund_accounting_premium,
            0 as reporting_refund_all_state_tax_amounts,
            0 as reporting_uw_endorsement_premium_amount,
            -- -- CAN EITHER COME FROM CTE_BRIGHT_POLICIES OR BE ADDED TO THE GOLD
            -- TABLE
            bp.policy_status,
            bp.cancellation_created_datetime,
            bp.cancellation_effective_date,
            bp.cancellation_status,
            bp.cancellation_category,
            bp.cancellation_reason,
            bp.nonrenewal_created_datetime,
            bp.nonrenewal_effective_date,
            bp.nonrenewal_status,
            bp.nonrenewal_category,
            bp.nonrenewal_reason,
            bp.pending_endorsement_flag,
            bp.in_progress_endorsement_request_flag,
            bp.state,
            bp.product_type,
            bp.product_line,
            bp.carrier_name,
            bp.bright_policy_deleted_at,
            -- --------------------------------------------------------
            -- -- BEGINNING OF ACCOUNTING DATA QUALITY CHECK LOGIC ----
            -- --------------------------------------------------------
            case
                when
                    abs(a.accounting_ledger_deferred_installments) > 0.0049
                    and abs(a.accounting_ledger_refunds_payable) > 0.0049
                    and abs(
                        a.accounting_ledger_refunds_payable
                        - reporting_refund_all_state_tax_amounts
                    )
                    > 0.0049  -- ---gold table
                then true
                else false
            end as di_payable_flag,
            case
                when
                    a.accounting_ledger_premium_receivable > 0.0049
                    and a.accounting_ledger_refunds_payable > 0.0049
                then true
                else false
            end as payable_receivable_flag,
            case
                when
                    a.accounting_ledger_premium_receivable > 0.0049
                    and a.accounting_ledger_premiums_received_in_advanced > 0.0049
                then true
                else false
            end as prem_rec_prem_in_adv_flag,
            case
                when
                    a.accounting_ledger_premium_receivable > 0.0049
                    and a.accounting_ledger_deferred_installments > 0.0049
                    and abs(
                        a.accounting_ledger_premium_receivable
                        - reporting_uw_endorsement_premium_amount
                    )
                    > 0.0049  -- ---gold table
                then true
                else false
            end as prem_rec_di_flag,
            case
                when a.accounting_ledger_premium_charge_off > 0.0049
                then true
                else false
            end as positive_charge_off_flag,
            case
                when a.accounting_ledger_unassigned_surplus < -0.0049
                then true
                else false
            end as negative_surplus_flag,
            case
                when a.accounting_ledger_unearned_premium_reserve < -0.0049
                then true
                else false
            end as negative_upr_flag,
            case
                when a.accounting_ledger_deferred_installments < -0.0049
                then true
                else false
            end as negative_di_flag,
            case
                when a.accounting_ledger_premium_receivable < -0.0049
                then true
                else false
            end as negative_prem_rec_flag,
            case
                when
                    bp.policy_status = 'cancelled'
                    and a.accounting_ledger_deferred_installments > 0.0049
                then true
                else false
            end as cancelled_with_di_flag,
            case
                when
                    bp.policy_status = 'cancelled'
                    and a.accounting_ledger_premium_receivable > 0.0049
                then true
                else false
            end as cancelled_with_prem_rec_flag,
            case
                when bp.policy_status = 'quote' and a.accounting_ledger_cash > 0.0049
                then true
                else false
            end as quote_with_cash_flag,
            case
                when
                    a.accounting_ledger_direct_premiums_written > 0.0049
                    and date_diff(day, current_date, a.effective_date) = 0
                then true
                else false
            end as dwp_not_in_force_flag,
            case
                when
                    a.accounting_ledger_premiums_received_in_advanced > 0.0049
                    -- and bp.carrier_name = 'Kin Interinsurance Network'
                    and date_diff(day, a.effective_date, current_date) >= 0
                then true
                else false
            end as pia_inforce_flag,
            case
                when a.accounting_ledger_premiums_received_in_advanced < -0.0049
                then true
                else false
            end as negative_prem_in_adv_flag,
            case
                when a.accounting_ledger_refunds_payable < -0.0049 then true else false
            end as negative_refunds_payable_flag,
            case
                when
                    abs(a.accounting_ledger_empa_fee_payable - 0) > 0.0049
                    and abs(a.accounting_ledger_empa_fee_payable - 2) > 0.0049
                then true
                else false
            end as empa_fee_bad_value_flag,
            case
                when
                    (a.accounting_ledger_refunds_payable - a.accounting_ledger_cash)
                    > 0.0049
                then true
                else false
            end as refunds_payable_gt_cash_flag,
            case
                when
                    a.accounting_ledger_figa_fee_receivable > 0.0049
                    and year(a.effective_date) != 2022
                    and bp.state != 'FL'
                then true
                else false
            end as figa_rec_not_fl22_flag,
            case
                when
                    bp.policy_status = 'cancelled'
                    and a.accounting_ledger_figa_fee_receivable > 0.0049
                then true
                else false
            end as cancelled_with_figa_rec_flag,
            case
                when abs(a.accounting_ledger_suspense_account) > 0.0049
                then true
                else false
            end as suspense_account_balance_flag,
            case
                when a.accounting_ledger_direct_premiums_written < -0.0049
                then true
                else false
            end as negative_dwp_flag,
            case
                when
                    a.accounting_ledger_direct_premiums_written > 0.0049
                    and date_diff(day, current_date, a.effective_date) > 0
                then true
                else false
            end as dwp_before_incept_flag,
            case
                when
                    (
                        a.accounting_ledger_unearned_premium_reserve
                        - a.accounting_ledger_direct_premiums_written
                    )
                    > 0.0049
                then true
                else false
            end as upr_gt_dwp_flag,
            case
                when
                    a.accounting_ledger_figa_fee_revenue > 0.0049
                    and year(a.effective_date) != 2022
                    and bp.state != 'FL'
                then true
                else false
            end as figa_rev_not_fl22_flag,
            case
                when
                    year(a.effective_date) = 2022
                    and bp.state = 'FL'
                    and bp.policy_status = 'in_force'
                    and date_diff(day, a.effective_date, current_date) >= 0
                    and abs(a.accounting_ledger_figa_fee_revenue) < 0.0049
                    and abs(a.accounting_ledger_figa_fee_receivable) < 0.0049
                then true
                else false
            end as fl22_no_figa_flag,
            case
                when
                    date_diff(day, a.expiration_date, current_date) > 0
                    and (
                        abs(a.accounting_ledger_premium_receivable) > 0.0049
                        or abs(a.accounting_ledger_premiums_received_in_advanced)
                        > 0.0049
                        or abs(a.accounting_ledger_deferred_installments) > 0.0049
                        or abs(a.accounting_ledger_change_in_unearned_premium_reserve)
                        > 0.0049
                        or abs(a.accounting_ledger_unearned_premium_reserve) > 0.0049
                        or abs(a.accounting_ledger_earned_surplus) > 0.0049
                        or abs(a.accounting_ledger_unearned_surplus) > 0.0049
                    )
                then true
                else false
            end as policy_not_zero_bal_flag,
            -- -- state specific fees == empa
            fees_table.empa_fee as fees_check_table_empa_fee,
            case
                when
                    fees_table.empa_fee = ''
                    and abs(a.accounting_ledger_empa_fee_payable) > 0.0049
                then true
                else false
            end as empa_fee_not_appropriate_state_flag,
            -- -- state specific fees == inspection fees
            fees_table.inspection_fee as fees_check_table_inspection_fee,
            case
                when
                    fees_table.inspection_fee = ''
                    and abs(a.accounting_ledger_inspection_fees) > 0.0049
                then true
                else false
            end as inspection_fee_not_appropriate_state_flag,
            -- --figa_fees
            fees_table.figa_fee_percent as fees_check_table_figa_fee_percent,
            round(
                fees_table.figa_fee_percent
                * a.accounting_ledger_direct_premiums_written,
                2
            ) as figa_fee_check_amount,
            case
                when
                    abs(figa_fee_check_amount - a.accounting_ledger_figa_fee_revenue)
                    < 0.5049
                then false
                when abs(a.accounting_ledger_direct_premiums_written) < 0.0049
                then false
                else true
            end as figa_fee_calc_flag,
            -- --state_tax
            fees_table.state_tax_fee_percent as fees_check_table_state_tax_fee_percent,
            round(
                fees_table.state_tax_fee_percent
                * a.accounting_ledger_direct_premiums_written,
                2
            ) as state_tax_check_amount,
            case
                when
                    abs(state_tax_check_amount - a.accounting_ledger_state_tax_revenue)
                    < 0.02
                then false
                when abs(a.accounting_ledger_direct_premiums_written) < 0.0049
                then false
                else true
            end as state_tax_calc_flag,
            -- --state_tax_1
            fees_table.state_tax_1_percent as fees_check_table_state_tax_1_percent,
            round(
                fees_table.state_tax_1_percent
                * a.accounting_ledger_direct_premiums_written,
                2
            ) as state_tax_1_check_amount,
            case
                when
                    abs(
                        state_tax_1_check_amount
                        - a.accounting_ledger_state_tax_1_payable
                    )
                    < 0.02
                then false
                when abs(a.accounting_ledger_direct_premiums_written) < 0.0049
                then false
                else true
            end as state_tax_1_calc_flag,
            -- --state_tax_2
            fees_table.state_tax_2_percent as fees_check_table_state_tax_2_percent,
            round(
                fees_table.state_tax_2_percent
                * a.accounting_ledger_direct_premiums_written,
                2
            ) as state_tax_2_check_amount,
            case
                when
                    abs(
                        state_tax_2_check_amount
                        - a.accounting_ledger_state_tax_2_payable
                    )
                    < 0.02
                then false
                when abs(a.accounting_ledger_direct_premiums_written) < 0.0049
                then false
                else true
            end as state_tax_2_calc_flag,
            -- --state_tax_3
            fees_table.state_tax_3_percent as fees_check_table_state_tax_3_percent,
            round(
                fees_table.state_tax_3_percent
                * a.accounting_ledger_direct_premiums_written,
                2
            ) as state_tax_3_check_amount,
            case
                when
                    abs(
                        state_tax_3_check_amount
                        - a.accounting_ledger_state_tax_3_payable
                    )
                    < 0.02
                then false
                when abs(a.accounting_ledger_direct_premiums_written) < 0.0049
                then false
                else true
            end as state_tax_3_calc_flag,
            -- -----------------------------------------------------
            -- -- BEGINNING OF INTERNAL CONSISTENCY CHECK LOGIC ----
            -- -----------------------------------------------------
            a.billing_total_amount_dollar_amount as billing_total_amount,
            (
                a.accounting_ledger_direct_premiums_written
                + a.accounting_ledger_unassigned_surplus
                + a.accounting_ledger_empa_fee_payable
                + a.accounting_ledger_state_tax_revenue
                + a.accounting_ledger_inspection_fees
                + a.accounting_ledger_program_administrator_fee_revenue
                + a.accounting_ledger_fee_revenue
                + a.accounting_ledger_figa_fee_revenue
                + a.accounting_ledger_refunds_payable
            ) as ledger_total_amount,
            (
                a.policy_transactions_total_written_premium_amount
                + a.policy_transactions_additional_surplus_and_fees_written_premium_amount
            ) as snapshots_total_amount,
            a.billing_total_accounting_premium_dollar_amount as billing_premium_amount,
            a.accounting_ledger_direct_premiums_written as ledger_premiums_amount,
            a.policy_transactions_total_written_premium_amount
            as snapshots_premium_amount,
            (
                a.policy_transactions_premium_tax_deduction_written_premium_amount
                + a.policy_transactions_fire_marshal_tax_deduction_written_premium_amount
            ) as sum_of_prorated_premium_tax_deductions,
            (
                a.billing_upcoming_amount_dollar_amount
                - a.billing_upcoming_accounting_premium_dollar_amount
            ) as billing_upcoming_surplus_fees_dollars,
            (
                reporting_rejected_total_amount_sum - reporting_rejected_premium_sum
            ) as billing_rejected_surplus_fees_dollars
        from {{ ref("mart_acct_agg_gold") }} as a
        inner join
            cte_bright_policies as bp
            on a.bright_policy_id = bp.bright_policy_id
            and a.term = bp.term
        left join
            {{ ref("fees_table") }} fees_table
            on fees_table.state = bp.state
            and fees_table.term_effective_date_begin <= date(a.effective_date)
            and fees_table.term_effective_date_end >= date(a.effective_date)
    ),
    cte_checks_step_two as (
        select
            *,
            coalesce(
                case
                    when
                        snapshots_premium_amount is null
                        and abs(ledger_premiums_amount) < 0.01
                    then 0.00
                    else (ledger_premiums_amount - snapshots_premium_amount)
                end,
                0
            ) as ledger_premium_to_snapshot_premium_difference,
            coalesce(
                (ledger_total_amount - billing_total_amount), 0
            ) as ledger_total_to_billing_total_difference,
            coalesce(
                (
                    ledger_premiums_amount
                    - billing_premium_amount
                    + sum_of_prorated_premium_tax_deductions
                ),
                0
            ) as ledger_premium_to_billing_premium_difference,
            coalesce(
                case
                    when
                        snapshots_total_amount is null
                        and abs(billing_total_amount) < 0.01
                    then 0.00
                    else (billing_total_amount - snapshots_total_amount)
                end,
                0
            ) as billing_total_to_snapshot_total_difference,
            coalesce(
                case
                    when
                        snapshots_premium_amount is null
                        and abs(billing_premium_amount) < 0.01
                    then 0.00
                    else
                        (
                            billing_premium_amount
                            - snapshots_premium_amount
                            + sum_of_prorated_premium_tax_deductions
                        )
                end,
                0
            ) as billing_premium_to_snapshot_premium_difference,
            case
                when abs(ledger_premium_to_snapshot_premium_difference) > 0.01
                then true
                else false
            end as ledger_premium_to_snapshot_premium_different,
            case
                when abs(ledger_total_to_billing_total_difference) > 0.01
                then true
                else false
            end as ledger_total_to_billing_total_different,
            case
                when abs(ledger_premium_to_billing_premium_difference) > 0.01
                then true
                else false
            end as ledger_premium_to_billing_premium_different,
            case
                when abs(billing_total_to_snapshot_total_difference) > 0.01
                then true
                else false
            end as billing_total_to_snapshot_total_different,
            case
                when abs(billing_premium_to_snapshot_premium_difference) > 0.01
                then true
                else false
            end as billing_premium_to_snapshot_premium_different
        from cte_checks_step_one
    ),
    cte_checks_step_three as (
        select
            *,
            case
                when
                    abs(ledger_premium_to_billing_premium_difference) < 0.01
                    and abs(ledger_total_to_billing_total_difference) < 0.01
                then 'None'
                when in_progress_endorsement_request_flag = true
                then 'In-Progress Endorsement'
                when pending_endorsement_flag = true
                then 'Future Effective Endorsement'
                when
                    cancellation_category = 'non_pay'
                    and cancellation_status = 'pending'
                then 'Pending Cancellation for No Payment of Premium Due'
                when
                    abs(reporting_rejected_premium_sum) > 0.01
                    and policy_status = 'in_force'
                    and abs(
                        ledger_premium_to_billing_premium_difference
                        - reporting_rejected_premium_sum
                    )
                    < 0.01
                then 'In-Force Policy - With Rejected Billing Transactions'
                when
                    abs(ledger_premium_to_billing_premium_difference) > 0.01
                    and abs(ledger_total_to_billing_total_difference) < 0.01
                then 'Premium Difference, Totals Match, Billing Allocation Issue'
                when
                    abs(ledger_premium_to_billing_premium_difference) < 0.01
                    and abs(
                        ledger_total_to_billing_total_difference
                        + billing_upcoming_surplus_fees_dollars
                    )
                    < 0.01
                then 'Premium Match, Total Diff, Upcoming Surplus Fees in Billing'
                when
                    abs(ledger_premium_to_billing_premium_difference) < 0.01
                    and abs(
                        ledger_total_to_billing_total_difference
                        + billing_upcoming_surplus_fees_dollars
                        - accounting_ledger_figa_fee_revenue
                    )
                    < 0.01
                then 'Premium Match, Total Diff, Upcoming Surplus Fees in Billing'
                when
                    abs(ledger_premiums_amount) < 0.01
                    and abs(billing_premium_amount) > 0.01
                    and policy_status in ('cancelled', 'non_renewed')
                then
                    'Cancelled/Non-Renewed Policy - With Non-Cancelled Billing Transactions'
                when
                    abs(ledger_premiums_amount) < 0.01
                    and abs(billing_premium_amount) > 0.01
                    and policy_status != 'in_force'
                then 'Other Inactive Policy - With Non-Cancelled Billing Transactions'
                when
                    abs(
                        ledger_premium_to_billing_premium_difference
                        - ledger_total_to_billing_total_difference
                    )
                    < 0.01
                    and abs(accounting_ledger_premium_charge_off) > 0.01
                    and abs(
                        ledger_premiums_amount
                        + accounting_ledger_premium_charge_off
                        - billing_premium_amount
                    )
                    < 0.01
                then 'Premium Chargeoff on Accounting Ledger Missing from Billing'
                else 'Other'
            end as ledger_to_billing_difference_type,
            case
                when abs(billing_premium_to_snapshot_premium_difference) < 0.01
                then 'None'
                when
                    nonrenewal_category = 'insured_request'
                    and nonrenewal_status = 'pending'
                then 'Insured Requested Future Non-Renewal'
                when nonrenewal_status = 'pending'
                then 'Kin Initiated Future Non-Renewal'
                when
                    abs(reporting_rejected_premium_sum) > 0.01
                    and policy_status = 'in_force'
                    and abs(
                        billing_premium_to_snapshot_premium_difference
                        + reporting_rejected_premium_sum
                    )
                    < 0.01
                then 'In-Force Policy - With Rejected Billing Transactions'
                when
                    abs(reporting_rejected_premium_sum) > 0.01
                    and policy_status != 'in_force'
                    and abs(
                        billing_premium_to_snapshot_premium_difference
                        + reporting_rejected_premium_sum
                    )
                    < 0.01
                then 'Not-In-Force Policy - With Rejected Billing Transactions'
                else 'Other'
            end as billing_to_snapshot_difference_type,
            case
                when bright_policy_deleted_at is not null then true else false
            end as ind_bright_policy_deleted,
            case
                when policy_status = 'expired' and abs(ledger_premiums_amount) < 0.01
                then true
                else false
            end as ind_policy_expired_and_no_accounting_dwp,
            case
                when date_diff(day, expiration_date, current_date) > 0
                then true
                else false
            end as policy_term_is_expired
        from cte_checks_step_two
    )
select
    *,
    case
        when
            ledger_to_billing_difference_type in (
                'Pending Cancellation for No Payment of Premium Due',
                'In-Progress Endorsement',
                'In-Force Policy - With Rejected Billing Transactions',
                'Future Effective Endorsement'
            )
        then true
        else false
    end as is_ledger_to_billing_premium_difference_transitory,
    rtrim(
        (case when di_payable_flag = true then 'di_payable_flag , ' else '' end) || (
            case
                when payable_receivable_flag = true
                then 'payable_receivable_flag , '
                else ''
            end
        )
        || (
            case
                when prem_rec_prem_in_adv_flag = true
                then 'prem_rec_prem_in_adv_flag , '
                else ''
            end
        )
        || (case when prem_rec_di_flag = true then 'prem_rec_di_flag, ' else '' end)
        || (
            case
                when positive_charge_off_flag = true
                then 'positive_charge_off_flag , '
                else ''
            end
        )
        || (
            case
                when negative_surplus_flag = true
                then 'negative_surplus_flag , '
                else ''
            end
        )
        || (case when negative_upr_flag = true then 'negative_upr_flag , ' else '' end)
        || (case when negative_di_flag = true then 'negative_di_flag , ' else '' end)
        || (
            case
                when negative_prem_rec_flag = true
                then 'negative_prem_rec_flag , '
                else ''
            end
        )
        || (
            case
                when cancelled_with_di_flag = true
                then 'cancelled_with_di_flag , '
                else ''
            end
        )
        || (
            case
                when cancelled_with_prem_rec_flag = true
                then 'cancelled_with_prem_rec_flag , '
                else ''
            end
        )
        || (
            case
                when quote_with_cash_flag = true then 'quote_with_cash_flag , ' else ''
            end
        )
        || (
            case
                when dwp_not_in_force_flag = true
                then 'dwp_not_in_force_flag , '
                else ''
            end
        )
        || (case when pia_inforce_flag = true then 'pia_inforce_flag , ' else '' end)
        || (
            case
                when negative_prem_in_adv_flag = true
                then 'negative_prem_in_adv_flag , '
                else ''
            end
        )
        || (
            case
                when negative_refunds_payable_flag = true
                then 'negative_refunds_payable_flag , '
                else ''
            end
        )
        || (
            case
                when empa_fee_bad_value_flag = true
                then 'empa_fee_bad_value_flag , '
                else ''
            end
        )
        || (
            case
                when refunds_payable_gt_cash_flag = true
                then 'refunds_payable_gt_cash_flag , '
                else ''
            end
        )
        || (
            case
                when figa_rec_not_fl22_flag = true
                then 'figa_rec_not_FL22_flag , '
                else ''
            end
        )
        || (
            case
                when cancelled_with_figa_rec_flag = true
                then 'cancelled_with_figa_rec_flag , '
                else ''
            end
        )
        || (
            case
                when suspense_account_balance_flag = true
                then 'suspense_account_balance_flag , '
                else ''
            end
        )
        || (case when negative_dwp_flag = true then 'negative_dwp_flag , ' else '' end)
        || (
            case
                when dwp_before_incept_flag = true
                then 'dwp_before_incept_flag , '
                else ''
            end
        )
        || (case when upr_gt_dwp_flag = true then 'upr_gt_dwp_flag , ' else '' end)
        || (
            case
                when figa_rev_not_fl22_flag = true
                then 'figa_rev_not_FL22_flag , '
                else ''
            end
        )
        || (case when fl22_no_figa_flag = true then 'FL22_no_figa_flag , ' else '' end)
        || (
            case
                when policy_not_zero_bal_flag = true
                then 'policy_not_zero_bal_flag , '
                else ''
            end
        )
        || (
            case
                when empa_fee_not_appropriate_state_flag = true
                then 'empa_fee_not_appropriate_state_flag , '
                else ''
            end
        )
        || (
            case
                when inspection_fee_not_appropriate_state_flag = true
                then 'inspection_fee_not_appropriate_state_flag , '
                else ''
            end
        )
        || (
            case when figa_fee_calc_flag = true then 'figa_fee_calc_flag , ' else '' end
        )
        || (
            case
                when state_tax_calc_flag = true then 'state_tax_calc_flag , ' else ''
            end
        )
        || (
            case
                when state_tax_1_calc_flag = true
                then 'state_tax_1_calc_flag , '
                else ''
            end
        )
        || (
            case
                when state_tax_2_calc_flag = true
                then 'state_tax_2_calc_flag , '
                else ''
            end
        )
        || (
            case
                when state_tax_3_calc_flag = true
                then 'state_tax_3_calc_flag , '
                else ''
            end
        ),
        -- (case when unassigned_surplus_difference_flag = true then
        -- 'unassigned_surplus_difference_flag , ' else '' end)
        ' , '
    ) as accounting_data_quality_check_flag_list
from cte_checks_step_three
